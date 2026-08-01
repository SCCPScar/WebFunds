import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/subscriptions_table.dart';

part 'subscription_dao.g.dart';

/// Raw SQL access only — no `Result`, no `Money`, no Domain type crosses
/// this boundary.
@DriftAccessor(tables: [Subscriptions])
class SubscriptionDao extends DatabaseAccessor<AppDatabase> with _$SubscriptionDaoMixin {
  SubscriptionDao(super.db);

  Stream<List<SubscriptionRow>> watchAll() {
    return (select(subscriptions)..orderBy([(s) => OrderingTerm.desc(s.createdAt)])).watch();
  }

  Future<List<SubscriptionRow>> getAll() => select(subscriptions).get();

  Future<SubscriptionRow?> findById(String id) {
    return (select(subscriptions)..where((s) => s.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(SubscriptionRow row) => into(subscriptions).insert(row);

  Future<void> updateRow(SubscriptionRow row) => update(subscriptions).replace(row);
}
