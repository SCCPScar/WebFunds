import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/errors/failure.dart';
import 'package:webfunds/core/result/result.dart';
import 'package:webfunds/features/weaver/application/usecases/complete_bank_link_usecase.dart';
import 'package:webfunds/features/weaver/application/usecases/list_institutions_usecase.dart';
import 'package:webfunds/features/weaver/application/usecases/unlink_bank_account_usecase.dart';
import 'package:webfunds/features/weaver/domain/repositories/bank_repository.dart';
import 'package:webfunds/features/weaver/domain/repositories/linked_bank_account_repository.dart';

class _StubBankRepository implements BankRepository {
  Result<List<BankAccount>>? exchangeResult;
  String? lastCountry;
  String? lastCode;

  @override
  Future<Result<List<BankInstitution>>> listInstitutions(String country) async {
    lastCountry = country;
    return const Success([BankInstitution(name: 'Millennium BCP', country: 'PT')]);
  }

  @override
  Future<Result<Uri>> startAuthorization({
    required BankInstitution institution,
    required String redirectUrl,
  }) => throw UnimplementedError();

  @override
  Future<Result<List<BankAccount>>> exchangeAuthorizationCode(String code) async {
    lastCode = code;
    return exchangeResult ?? const Success(<BankAccount>[]);
  }

  @override
  Future<Result<BankBalance>> fetchBalance(String bankAccountId) => throw UnimplementedError();

  @override
  Future<Result<List<BankTransaction>>> fetchTransactions(String bankAccountId) =>
      throw UnimplementedError();
}

class _StubLinkedBankAccountRepository implements LinkedBankAccountRepository {
  List<BankAccount>? lastSaved;
  Result<void>? saveAllResult;
  String? lastUnlinkedId;

  @override
  Stream<Result<List<BankAccount>>> watchAll() => throw UnimplementedError();

  @override
  Future<Result<void>> saveAll(List<BankAccount> accounts) async {
    lastSaved = accounts;
    return saveAllResult ?? const Success(null);
  }

  @override
  Future<Result<void>> unlink(String id) async {
    lastUnlinkedId = id;
    return const Success(null);
  }
}

void main() {
  group('ListInstitutionsUseCase', () {
    test('forwards the country to the repository', () async {
      final repository = _StubBankRepository();
      final useCase = ListInstitutionsUseCase(repository);

      final result = await useCase('PT');

      expect(result.isSuccess, isTrue);
      expect(repository.lastCountry, 'PT');
      expect(result.dataOrNull!.single.name, 'Millennium BCP');
    });
  });

  group('CompleteBankLinkUseCase', () {
    test('exchanges the code then persists the returned Accounts', () async {
      final bankAccount = const BankAccount(
        id: 'acc-1',
        institutionName: 'Millennium BCP',
        iban: 'PT50...',
        displayName: 'Conta à ordem',
      );
      final bankRepository = _StubBankRepository()..exchangeResult = Success([bankAccount]);
      final linkedRepository = _StubLinkedBankAccountRepository();
      final useCase = CompleteBankLinkUseCase(bankRepository, linkedRepository);

      final result = await useCase('auth-code-123');

      expect(result.isSuccess, isTrue);
      expect(bankRepository.lastCode, 'auth-code-123');
      expect(linkedRepository.lastSaved, [bankAccount]);
    });

    test('does not persist anything when the exchange fails', () async {
      final bankRepository = _StubBankRepository()
        ..exchangeResult = const ResultError(UnknownFailure());
      final linkedRepository = _StubLinkedBankAccountRepository();
      final useCase = CompleteBankLinkUseCase(bankRepository, linkedRepository);

      final result = await useCase('bad-code');

      expect(result.isError, isTrue);
      expect(linkedRepository.lastSaved, isNull);
    });
  });

  group('UnlinkBankAccountUseCase', () {
    test('forwards the account id to the repository', () async {
      final repository = _StubLinkedBankAccountRepository();
      final useCase = UnlinkBankAccountUseCase(repository);

      final result = await useCase('acc-1');

      expect(result.isSuccess, isTrue);
      expect(repository.lastUnlinkedId, 'acc-1');
    });
  });
}
