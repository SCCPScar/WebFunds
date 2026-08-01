import '../../../../core/result/result.dart';
import '../entities/app_notification.dart';
import '../entities/notification_category.dart';
import '../entities/notification_priority.dart';
import '../entities/notification_state.dart';

/// Contract for Notification persistence, following the same Repository
/// pattern as everywhere else in WebFunds.
abstract class NotificationRepository {
  /// Every notification regardless of state, newest first — the page
  /// groups/filters them itself.
  Stream<Result<List<AppNotification>>> watchAll();

  /// Count of `NotificationState.unread` notifications, for the badge on
  /// `AppShell`'s bell icon.
  Stream<Result<int>> watchUnreadCount();

  /// Creates a notification unless one with the same `sourceKey` already
  /// exists — how detection stays idempotent. Returns `null` (not an
  /// error) when it already existed.
  Future<Result<AppNotification?>> createIfAbsent({
    required String title,
    required String description,
    required NotificationCategory category,
    required NotificationPriority priority,
    required String sourceKey,
    String? relatedEntityId,
  });

  Future<Result<AppNotification>> updateState(String id, NotificationState state);
}
