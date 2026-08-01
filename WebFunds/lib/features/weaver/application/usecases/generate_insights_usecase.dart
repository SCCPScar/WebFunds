import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../../../shared/models/money.dart';
import '../../../accounts/application/usecases/get_account_balances_usecase.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../domain/entities/weaver_insight.dart';
import '../engine/weaver_engine.dart';

/// Gathers the same Account/Transaction/balance data
/// `LocalDashboardRepository.getSummary()` already gathers for Central,
/// then hands it to `WeaverEngine`. No parameters — always analyzes the
/// owner's current state.
class GenerateInsightsUseCase extends UseCase<List<WeaverInsight>, NoParams> {
  const GenerateInsightsUseCase(
    this._accountRepository,
    this._transactionRepository,
    this._getAccountBalances,
    this._engine,
  );

  final AccountRepository _accountRepository;
  final TransactionRepository _transactionRepository;
  final GetAccountBalancesUseCase _getAccountBalances;
  final WeaverEngine _engine;

  @override
  Future<Result<List<WeaverInsight>>> call(NoParams params) async {
    final accountsResult = await _accountRepository.watchAll().first;
    if (accountsResult case ResultError(:final failure)) {
      return ResultError(failure);
    }
    final accounts = accountsResult.dataOrNull ?? const <Account>[];

    final balancesResult = await _getAccountBalances(accounts);
    if (balancesResult case ResultError(:final failure)) {
      return ResultError(failure);
    }
    final balances = balancesResult.dataOrNull ?? const <String, Money>{};

    final transactionsResult = await _transactionRepository.getAll();
    if (transactionsResult case ResultError(:final failure)) {
      return ResultError(failure);
    }
    final transactions = transactionsResult.dataOrNull ?? const <Transaction>[];

    return Success(
      _engine.generateInsights(accounts: accounts, balances: balances, transactions: transactions),
    );
  }
}
