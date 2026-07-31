import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../entities/transaction.dart';
import '../entities/transaction_type.dart';

/// Contract for Transaction persistence, following the same Repository
/// pattern established by `AccountRepository`/`FinancialCycleRepository`.
abstract class TransactionRepository {
  /// Transactions for one Financial Cycle, newest first, updating
  /// automatically — `docs/01-Experience/03-Finances.md`: "Transactions
  /// are grouped by the active Financial Cycle by default."
  Stream<Result<List<Transaction>>> watchByCycle(String financialCycleId);

  /// Every Transaction ever recorded, across every Financial Cycle — the
  /// only view of a Transaction that isn't scoped to one Cycle. Powers
  /// derived, always-current Account balances (Central's Dashboard),
  /// which must reflect Cycles that have since closed.
  Future<Result<List<Transaction>>> getAll();

  /// `id`, `createdAt` and `updatedAt` are not parameters — assigning
  /// them is this layer's responsibility, never the caller's.
  Future<Result<Transaction>> create({
    required String financialCycleId,
    required String accountId,
    required TransactionType type,
    required Money amount,
    required DateTime transactionDate,
    String? merchant,
    String? category,
  });

  /// Corrects merchant/category after the fact — Finances' "Correct
  /// categories" primary goal. Never touches amount, date or type: those
  /// are immutable historical facts per the Transactions doc's Core
  /// Principles.
  Future<Result<Transaction>> updateMerchantAndCategory(
    String id, {
    String? merchant,
    String? category,
  });
}
