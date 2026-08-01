import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../../../shared/models/money.dart';
import '../../../financial_cycles/domain/entities/financial_cycle.dart';
import '../../../financial_cycles/domain/repositories/financial_cycle_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/entities/transaction_type.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../domain/entities/category_breakdown_entry.dart';
import '../../domain/entities/cycle_report.dart';
import '../../domain/entities/merchant_breakdown_entry.dart';

/// Builds a Financial Cycle Report (`docs/02-Domain/10-Reports.md`) purely
/// from what already exists — Transactions and past closed Cycles. Never
/// writes anything; Reports "never modify data".
class GetCycleReportUseCase extends UseCase<CycleReport, FinancialCycle> {
  const GetCycleReportUseCase(this._transactionRepository, this._financialCycleRepository);

  final TransactionRepository _transactionRepository;
  final FinancialCycleRepository _financialCycleRepository;

  @override
  Future<Result<CycleReport>> call(FinancialCycle cycle) async {
    final transactionsResult = await _transactionRepository.watchByCycle(cycle.id).first;
    if (transactionsResult case ResultError(:final failure)) {
      return ResultError(failure);
    }
    final transactions = transactionsResult.dataOrNull ?? const <Transaction>[];

    final income = transactions.where((t) => t.type == TransactionType.income).toList();
    final expenses = transactions.where((t) => t.type == TransactionType.expense).toList();

    final totalIncome = _sum(income);
    final totalExpenses = _sum(expenses);

    final (previousIncome, previousExpenses) = await _previousCycleTotals(cycle);

    return Success(
      CycleReport(
        cycle: cycle,
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        transactionCount: transactions.length,
        categoryBreakdown: _categoryBreakdown(expenses, totalExpenses),
        merchantBreakdown: _merchantBreakdown(expenses),
        largestExpense: _largest(expenses),
        largestIncome: _largest(income),
        previousCycleIncome: previousIncome,
        previousCycleExpenses: previousExpenses,
      ),
    );
  }

  Money _sum(List<Transaction> transactions) {
    return transactions.fold(Money.zero(), (sum, t) => sum + t.amount);
  }

  Transaction? _largest(List<Transaction> transactions) {
    if (transactions.isEmpty) return null;
    return transactions.reduce(
      (a, b) => a.amount.minorUnits >= b.amount.minorUnits ? a : b,
    );
  }

  List<CategoryBreakdownEntry> _categoryBreakdown(List<Transaction> expenses, Money totalExpenses) {
    final totals = <String, int>{};
    for (final t in expenses) {
      final key = t.category ?? 'Sem categoria';
      totals[key] = (totals[key] ?? 0) + t.amount.minorUnits;
    }
    final entries = totals.entries
        .map(
          (e) => CategoryBreakdownEntry(
            category: e.key,
            total: Money.fromMinorUnits(e.value),
            percentage: totalExpenses.minorUnits == 0 ? 0 : e.value / totalExpenses.minorUnits,
          ),
        )
        .toList()
      ..sort((a, b) => b.total.minorUnits.compareTo(a.total.minorUnits));
    return entries;
  }

  List<MerchantBreakdownEntry> _merchantBreakdown(List<Transaction> expenses) {
    final totals = <String, int>{};
    final visits = <String, int>{};
    for (final t in expenses) {
      final key = t.merchant ?? 'Sem merchant';
      totals[key] = (totals[key] ?? 0) + t.amount.minorUnits;
      visits[key] = (visits[key] ?? 0) + 1;
    }
    final entries = totals.entries
        .map(
          (e) => MerchantBreakdownEntry(
            merchant: e.key,
            total: Money.fromMinorUnits(e.value),
            visits: visits[e.key]!,
          ),
        )
        .toList()
      ..sort((a, b) => b.total.minorUnits.compareTo(a.total.minorUnits));
    return entries;
  }

  Future<(Money?, Money?)> _previousCycleTotals(FinancialCycle cycle) async {
    final closedResult = await _financialCycleRepository.getAllClosed();
    if (closedResult case ResultError()) return (null, null);

    final closed = closedResult.dataOrNull ?? const <FinancialCycle>[];
    final previousCandidates = closed
        .where((c) => c.id != cycle.id && c.startDate.isBefore(cycle.startDate))
        .toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
    if (previousCandidates.isEmpty) return (null, null);

    final previous = previousCandidates.first;
    final previousTransactionsResult = await _transactionRepository.watchByCycle(previous.id).first;
    if (previousTransactionsResult case ResultError()) return (null, null);

    final previousTransactions = previousTransactionsResult.dataOrNull ?? const <Transaction>[];
    final previousIncome =
        _sum(previousTransactions.where((t) => t.type == TransactionType.income).toList());
    final previousExpenses =
        _sum(previousTransactions.where((t) => t.type == TransactionType.expense).toList());
    return (previousIncome, previousExpenses);
  }
}
