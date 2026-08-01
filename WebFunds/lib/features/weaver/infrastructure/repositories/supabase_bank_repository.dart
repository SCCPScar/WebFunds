import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../services/supabase/supabase_service.dart';
import '../../../../shared/models/money.dart';
import '../../domain/repositories/bank_repository.dart';

/// Real [BankRepository] — calls the `banking-proxy` Supabase Edge
/// Function, the only place `ENABLE_BANKING_PRIVATE_KEY` exists. Same
/// shape as `SupabaseWeaverRepository`: nothing here ever holds that
/// key, `supabase_flutter` attaches the caller's session automatically,
/// and the Function verifies it.
///
/// Enable Banking's exact response field names for `/aspsps` and
/// `/accounts/{id}/details` weren't independently verifiable while this
/// was written (their docs site blocks non-browser fetches) — parsing
/// below is deliberately defensive, tries a couple of reasonable field
/// names, and degrades to a placeholder rather than throwing when a
/// field is missing. If real responses use different names, only the
/// small `_parse*` helpers below need adjusting — nothing else in the
/// app depends on Enable Banking's raw shape.
class SupabaseBankRepository implements BankRepository {
  const SupabaseBankRepository(this._supabaseService);

  final SupabaseService _supabaseService;

  static const _functionName = 'banking-proxy';

  Future<Result<Map<String, dynamic>>> _invoke(Map<String, dynamic> body) async {
    if (!_supabaseService.isInitialized) {
      return const ResultError(ServerFailure(message: 'A ligação bancária ainda não está configurada.'));
    }

    try {
      final response = await _supabaseService.client.functions.invoke(_functionName, body: body);
      final data = response.data;
      if (data is! Map) {
        throw const ServerException('O proxy bancário devolveu uma resposta inesperada.');
      }
      if (data['error'] != null) {
        throw ServerException(data['error'].toString());
      }
      return Success(Map<String, dynamic>.from(data));
    } on AppException catch (e) {
      return ResultError(mapExceptionToFailure(e));
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(ServerException('Falha ao comunicar com o banco.', cause: e)),
      );
    }
  }

  @override
  Future<Result<List<BankInstitution>>> listInstitutions(String country) async {
    final result = await _invoke({'action': 'list_institutions', 'country': country});
    return result.fold(
      onSuccess: (data) {
        final raw = data['aspsps'];
        if (raw is! List) return const Success(<BankInstitution>[]);
        final institutions = <BankInstitution>[];
        for (final entry in raw) {
          if (entry is! Map) continue;
          final name = entry['name'];
          final entryCountry = entry['country'];
          if (name is String && entryCountry is String) {
            institutions.add(BankInstitution(name: name, country: entryCountry));
          }
        }
        return Success(institutions);
      },
      onError: (failure) => ResultError(failure),
    );
  }

  @override
  Future<Result<Uri>> startAuthorization({
    required BankInstitution institution,
    required String redirectUrl,
  }) async {
    final result = await _invoke({
      'action': 'start_authorization',
      'aspspName': institution.name,
      'aspspCountry': institution.country,
      'redirectUrl': redirectUrl,
    });
    return result.fold(
      onSuccess: (data) {
        final url = data['url'];
        if (url is! String) {
          return const ResultError(
            ServerFailure(message: 'O banco não devolveu um URL de autorização.'),
          );
        }
        final uri = Uri.tryParse(url);
        if (uri == null) {
          return const ResultError(ServerFailure(message: 'O URL de autorização é inválido.'));
        }
        return Success(uri);
      },
      onError: (failure) => ResultError(failure),
    );
  }

  @override
  Future<Result<List<BankAccount>>> exchangeAuthorizationCode(String code) async {
    final sessionResult = await _invoke({'action': 'exchange_session', 'code': code});
    if (sessionResult case ResultError(:final failure)) {
      return ResultError(failure);
    }

    final rawAccounts = sessionResult.dataOrNull?['accounts'];
    if (rawAccounts is! List) {
      return const Success(<BankAccount>[]);
    }

    final accounts = <BankAccount>[];
    for (final entry in rawAccounts) {
      if (entry is! Map) continue;
      final uid = entry['uid'];
      if (uid is! String) continue;

      final detailsResult = await _invoke({'action': 'get_account_details', 'accountId': uid});
      final details = detailsResult.dataOrNull;
      accounts.add(
        BankAccount(
          id: uid,
          institutionName: _stringOrDefault(details?['product'], 'Conta bancária'),
          iban: _stringOrDefault(_extractIban(details), ''),
          displayName: _stringOrDefault(details?['name'] ?? details?['product'], 'Conta ligada'),
        ),
      );
    }

    return Success(accounts);
  }

  @override
  Future<Result<BankBalance>> fetchBalance(String bankAccountId) async {
    final result = await _invoke({'action': 'get_balances', 'accountId': bankAccountId});
    return result.fold(
      onSuccess: (data) {
        final balances = data['balances'];
        if (balances is! List || balances.isEmpty) {
          return const ResultError(
            ServerFailure(message: 'O banco não devolveu nenhum saldo para esta conta.'),
          );
        }
        final first = balances.first;
        if (first is! Map) {
          return const ResultError(ServerFailure(message: 'Resposta de saldo inesperada.'));
        }
        final balanceAmount = first['balance_amount'];
        final amountString = balanceAmount is Map ? balanceAmount['amount'] : null;
        final currency = balanceAmount is Map ? balanceAmount['currency'] : null;
        final amount = double.tryParse(amountString?.toString() ?? '') ?? 0;

        return Success(
          BankBalance(
            bankAccountId: bankAccountId,
            amount: Money.fromMajorUnits(amount, currency: currency is String ? currency : '€'),
            asOf: DateTime.now(),
          ),
        );
      },
      onError: (failure) => ResultError(failure),
    );
  }

  @override
  Future<Result<List<BankTransaction>>> fetchTransactions(String bankAccountId) async {
    final result = await _invoke({'action': 'get_transactions', 'accountId': bankAccountId});
    return result.fold(
      onSuccess: (data) {
        final raw = data['transactions'];
        if (raw is! List) return const Success(<BankTransaction>[]);

        final transactions = <BankTransaction>[];
        for (final entry in raw) {
          if (entry is! Map) continue;
          final transactionAmount = entry['transaction_amount'];
          final amountString = transactionAmount is Map ? transactionAmount['amount'] : null;
          final currency = transactionAmount is Map ? transactionAmount['currency'] : null;
          final amount = double.tryParse(amountString?.toString() ?? '');
          final bookingDate = DateTime.tryParse(entry['booking_date']?.toString() ?? '');
          if (amount == null || bookingDate == null) continue;

          transactions.add(
            BankTransaction(
              id: _stringOrDefault(entry['entry_reference'] ?? entry['transaction_id'], ''),
              bankAccountId: bankAccountId,
              amount: Money.fromMajorUnits(amount.abs(), currency: currency is String ? currency : '€'),
              bookingDate: bookingDate,
              remittanceInformation: entry['remittance_information_unstructured']?.toString(),
            ),
          );
        }
        return Success(transactions);
      },
      onError: (failure) => ResultError(failure),
    );
  }

  String? _extractIban(Map<String, dynamic>? details) {
    final accountId = details?['account_id'];
    if (accountId is Map && accountId['iban'] is String) return accountId['iban'] as String;
    if (details?['iban'] is String) return details!['iban'] as String;
    return null;
  }

  String _stringOrDefault(Object? value, String fallback) {
    if (value is String && value.isNotEmpty) return value;
    return fallback;
  }
}
