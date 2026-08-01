import '../../../../shared/models/money.dart';
import '../../../financial_cycles/domain/entities/financial_cycle.dart';
import '../../../transactions/domain/entities/transaction.dart';
import 'category_breakdown_entry.dart';
import 'merchant_breakdown_entry.dart';

/// `docs/02-Domain/10-Reports.md`'s Financial Cycle Report — deliberately
/// excludes Reserved Money/Available Balance (not tracked yet), Dream
/// Contributions and Mysteries (neither is scoped to a Cycle yet).
class CycleReport {
  const CycleReport({
    required this.cycle,
    required this.totalIncome,
    required this.totalExpenses,
    required this.transactionCount,
    required this.categoryBreakdown,
    required this.merchantBreakdown,
    this.largestExpense,
    this.largestIncome,
    this.previousCycleIncome,
    this.previousCycleExpenses,
  });

  final FinancialCycle cycle;
  final Money totalIncome;
  final Money totalExpenses;
  final int transactionCount;
  final List<CategoryBreakdownEntry> categoryBreakdown;
  final List<MerchantBreakdownEntry> merchantBreakdown;
  final Transaction? largestExpense;
  final Transaction? largestIncome;

  /// Null when there is no earlier closed cycle to compare against.
  final Money? previousCycleIncome;
  final Money? previousCycleExpenses;

  Money get net => totalIncome - totalExpenses;
}
