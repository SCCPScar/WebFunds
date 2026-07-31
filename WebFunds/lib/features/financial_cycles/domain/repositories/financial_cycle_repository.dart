import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../entities/financial_cycle.dart';

/// Contract for Financial Cycle persistence, following the same
/// Repository pattern established by `AccountRepository`.
abstract class FinancialCycleRepository {
  /// The single cycle currently Active, if any — updates automatically.
  Stream<Result<FinancialCycle?>> watchActive();

  /// One-shot equivalent of [watchActive], used by [start] to enforce
  /// "cycles never overlap": only one Active cycle may exist at a time.
  Future<Result<FinancialCycle?>> getActive();

  /// `id`, `status` and the timestamps are not parameters — assigning
  /// them is this layer's responsibility, never the caller's. Always
  /// starts the cycle as `active`.
  Future<Result<FinancialCycle>> start({
    String? name,
    required DateTime startDate,
    required Money openingBalance,
  });

  /// Moves the cycle to `closed`, stamping its end date and closing
  /// balance.
  Future<Result<FinancialCycle>> close(String id, {required Money closingBalance});
}
