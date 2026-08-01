import '../../../../services/database/app_database.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_category.dart';
import '../../domain/entities/notification_priority.dart';
import '../../domain/entities/notification_state.dart';

/// The single place in WebFunds that knows both the Drift schema and the
/// `AppNotification` Domain entity.
class NotificationMapper {
  const NotificationMapper._();

  static AppNotification toDomain(NotificationRow row) {
    return AppNotification(
      id: row.id,
      title: row.title,
      description: row.description,
      category: NotificationCategory.values.byName(row.category),
      priority: NotificationPriority.values.byName(row.priority),
      state: NotificationState.values.byName(row.state),
      sourceKey: row.sourceKey,
      relatedEntityId: row.relatedEntityId,
      createdAt: row.createdAt,
    );
  }

  static NotificationRow toRow(AppNotification notification) {
    return NotificationRow(
      id: notification.id,
      title: notification.title,
      description: notification.description,
      category: notification.category.name,
      priority: notification.priority.name,
      state: notification.state.name,
      sourceKey: notification.sourceKey,
      relatedEntityId: notification.relatedEntityId,
      createdAt: notification.createdAt,
    );
  }
}
