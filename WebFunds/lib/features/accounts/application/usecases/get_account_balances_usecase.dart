import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/entities/transaction_type.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../domain/entities/account.dart';

/// Derives each Account's *current* balance — opening balance plus its
/// Transactions — the Application-layer use case `Account.openingBalance`
/// always pointed to as "computed once Transactions exist" rather than
/// stored, to avoid two competing sources of truth.
class GetAccountBalancesUseCase {
  const GetAccountBalancesUseCase(this._transactionRepository);

  final TransactionRepository _transactionRepository;

  /// One current balance per given Account, keyed by [Account.id].
  Future<Result<Map<String, Money>>> call(List<Account> accounts) async {
    final result = await _transactionRepository.getAll();
    return result.fold(
      onSuccess: (transactions) => Success({
        for (final account in accounts) account.id: _currentBalance(account, transactions),
      }),
      onError: ResultError.new,
    );
  }

  /// Transfers are deliberately excluded — the Transactions doc defines
  /// them as "neutral overall", and this model doesn't yet track a
  /// destination Account to split the movement across two balances.
  Money _currentBalance(Account account, List<Transaction> transactions) {
    return transactions.where((t) => t.accountId == account.id).fold(
      account.openingBalance,
      (balance, t) => switch (t.type) {
        TransactionType.income => balance + t.amount,
        TransactionType.expense => balance - t.amount,
        TransactionType.transfer => balance,
      },
    );
  }
}
