import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../entities/subscription.dart';
import '../entities/subscription_frequency.dart';
import '../entities/subscription_status.dart';

/// Contract for confirmed Subscription persistence — detection itself
/// never touches this; only confirming a suggestion does.
abstract class SubscriptionRepository {
  /// Every Subscription regardless of status, updating automatically —
  /// the page groups them into sections itself.
  Stream<Result<List<Subscription>>> watchAll();

  /// One-shot equivalent, used by detection to exclude merchants that
  /// already have a Subscription (any status) so they aren't re-suggested.
  Future<Result<List<Subscription>>> getAll();

  /// `id`, `status` (`active`) and the timestamps are not parameters —
  /// assigning them is this layer's responsibility.
  Future<Result<Subscription>> create({
    required String merchant,
    required Money expectedAmount,
    required SubscriptionFrequency frequency,
    DateTime? nextExpectedDate,
    String? category,
  });

  Future<Result<Subscription>> updateStatus(String id, SubscriptionStatus status);
}
