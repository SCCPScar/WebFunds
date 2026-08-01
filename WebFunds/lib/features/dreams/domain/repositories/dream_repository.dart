import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../entities/dream.dart';
import '../entities/dream_movement.dart';

/// Contract for Dream persistence, following the same Repository pattern
/// as everywhere else in WebFunds.
abstract class DreamRepository {
  /// Every Dream that isn't archived or cancelled, updating automatically.
  Stream<Result<List<Dream>>> watchActive();

  /// One-shot equivalent of `watchActive` — used by detection, which
  /// needs a snapshot rather than a live subscription.
  Future<Result<List<Dream>>> getActive();

  Future<Result<Dream?>> getById(String id);

  /// Live view of one Dream — what `_DreamDetailSheet` watches so the
  /// progress bar updates the instant a contribution/withdrawal lands,
  /// instead of showing a snapshot taken when the sheet was opened.
  Stream<Result<Dream?>> watchById(String id);

  Stream<Result<List<DreamMovement>>> watchMovements(String dreamId);

  /// `id`, `status`, `reservedAmount`, `createdAt` and `updatedAt` are not
  /// parameters — a new Dream always starts Active with nothing reserved.
  Future<Result<Dream>> create({
    required String name,
    required Money targetAmount,
    String? description,
    DateTime? targetDate,
    String? category,
  });

  /// Records a contribution and atomically updates the Dream's reserved
  /// amount — completing the Dream if the target is reached.
  Future<Result<Dream>> addContribution({
    required String dreamId,
    required Money amount,
    String? notes,
  });

  /// Records a withdrawal and atomically reduces the Dream's reserved
  /// amount. Fails validation if it would go negative.
  Future<Result<Dream>> addWithdrawal({
    required String dreamId,
    required Money amount,
    String? notes,
  });

  Future<Result<Dream>> archive(String id);

  Future<Result<Dream>> cancel(String id);
}
