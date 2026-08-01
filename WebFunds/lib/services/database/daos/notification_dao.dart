import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/notifications_table.dart';

part 'notification_dao.g.dart';

/// Raw SQL access only — no `Result`, no Domain type crosses this
/// boundary.
@DriftAccessor(tables: [Notifications])
class NotificationDao extends DatabaseAccessor<AppDatabase> with _$NotificationDaoMixin {
  NotificationDao(super.db);

  Stream<List<NotificationRow>> watchAll() {
    return (select(notifications)..orderBy([(n) => OrderingTerm.desc(n.createdAt)])).watch();
  }

  Future<NotificationRow?> findBySourceKey(String sourceKey) {
    return (select(notifications)..where((n) => n.sourceKey.equals(sourceKey))).getSingleOrNull();
  }

  Future<NotificationRow?> findById(String id) {
    return (select(notifications)..where((n) => n.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(NotificationRow row) => into(notifications).insert(row);

  Future<void> updateRow(NotificationRow row) => update(notifications).replace(row);
}
