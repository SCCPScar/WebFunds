import '../../../../core/result/result.dart';
import '../../../../core/utils/clock.dart';
import '../../../../shared/models/money.dart';
import '../../../accounts/application/usecases/get_account_balances_usecase.dart';
import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// Real implementation of [DashboardRepository] — derives both values
/// from Accounts and Transactions instead of returning fixed numbers.
class LocalDashboardRepository implements DashboardRepository {
  const LocalDashboardRepository(
    this._accountRepository,
    this._transactionRepository,
    this._getAccountBalances,
    this._clock,
  );

  final AccountRepository _accountRepository;
  final TransactionRepository _transactionRepository;
  final GetAccountBalancesUseCase _getAccountBalances;
  final Clock _clock;

  static const Duration _recentWindow = Duration(days: 7);

  @override
  Future<Result<DashboardSummary>> getSummary() async {
    final accountsResult = await _accountRepository.watchAll().first;
    if (accountsResult case ResultError(:final failure)) {
      return ResultError(failure);
    }
    final accounts = accountsResult.dataOrNull ?? const [];

    final balancesResult = await _getAccountBalances(accounts);
    if (balancesResult case ResultError(:final failure)) {
      return ResultError(failure);
    }
    final balances = balancesResult.dataOrNull ?? const {};
    final totalBalance = balances.values.fold(Money.zero(), (sum, balance) => sum + balance);

    final transactionsResult = await _transactionRepository.getAll();
    if (transactionsResult case ResultError(:final failure)) {
      return ResultError(failure);
    }
    final transactions = transactionsResult.dataOrNull ?? const [];

    final recentCutoff = _clock.now().subtract(_recentWindow);
    final recentActivityCount =
        transactions.where((t) => !t.transactionDate.isBefore(recentCutoff)).length;

    return Success(
      DashboardSummary(totalBalance: totalBalance, recentActivityCount: recentActivityCount),
    );
  }
}
