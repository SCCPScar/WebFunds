import '../../../../core/result/result.dart';
import '../entities/mystery.dart';
import '../entities/mystery_reason.dart';
import '../entities/mystery_status.dart';

/// Contract for Mystery persistence, following the same Repository
/// pattern as everywhere else in WebFunds.
abstract class MysteryRepository {
  /// Every Mystery regardless of status, updating automatically — the
  /// page groups them into sections itself.
  Stream<Result<List<Mystery>>> watchAll();

  /// One-shot equivalent, used by detection to skip Transactions that
  /// already have a Mystery (any status) — "a Transaction may have zero
  /// or one active Mystery."
  Future<Result<List<Mystery>>> getAll();

  /// `id`, `status` (`open`) and the timestamps are not parameters —
  /// assigning them is this layer's responsibility.
  Future<Result<Mystery>> create({
    required String transactionId,
    required MysteryReason reason,
    String? notes,
  });

  Future<Result<Mystery>> updateStatus(String id, MysteryStatus status);

  Future<Result<Mystery>> updateNotes(String id, String? notes);
}
