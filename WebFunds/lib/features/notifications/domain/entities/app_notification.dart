import 'notification_category.dart';
import 'notification_priority.dart';
import 'notification_state.dart';

/// A single entry in the Notification Center —
/// `docs/02-Domain/09-Notifications.md` / `docs/01-Experience/08-Notifications.md`.
/// Deliberately in-app only for v1: no push token/FCM/APNs integration,
/// no Quiet Hours scheduling, no Daily/Weekly Summary generation — all of
/// those need background execution this app doesn't have. What's real is
/// the Notification Center itself: detected events, read/archive/dismiss
/// state, and a related entity to jump to.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.state,
    required this.sourceKey,
    required this.createdAt,
    this.relatedEntityId,
  });

  final String id;
  final String title;
  final String description;
  final NotificationCategory category;
  final NotificationPriority priority;
  final NotificationState state;

  /// Identifies the real-world event this notification represents (e.g.
  /// `"dream:completed:<dreamId>"`) — detection is idempotent against
  /// this, never creating a second notification for the same event.
  final String sourceKey;

  final DateTime createdAt;

  /// The Dream/Mystery/Transaction id `Notification Actions` (Open
  /// Dream/Open Mystery) would navigate to. Nullable because not every
  /// notification refers to one entity.
  final String? relatedEntityId;
}
