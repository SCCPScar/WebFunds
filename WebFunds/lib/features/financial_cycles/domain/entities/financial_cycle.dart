import '../../../../shared/models/money.dart';
import 'financial_cycle_status.dart';

/// A Financial Cycle — WebFunds' primary unit of time, started by the
/// owner rather than tied to the calendar. Deliberately excludes
/// income/expense/reserved/available totals: those are *derived* from
/// Transactions (once that feature exists), never stored here, to avoid
/// two competing sources of truth — the same reasoning `Account` already
/// applies to its current balance.
class FinancialCycle {
  const FinancialCycle({
    required this.id,
    this.name,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.openingBalance,
    this.closingBalance,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;

  /// Optional — the owner may leave a cycle unnamed.
  final String? name;

  final DateTime startDate;

  /// Set only once the cycle is closed.
  final DateTime? endDate;

  final FinancialCycleStatus status;

  final Money openingBalance;

  /// Set only once the cycle is closed.
  final Money? closingBalance;

  final DateTime createdAt;
  final DateTime updatedAt;
}
