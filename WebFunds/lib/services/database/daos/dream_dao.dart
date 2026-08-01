import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/dream_movements_table.dart';
import '../tables/dreams_table.dart';

part 'dream_dao.g.dart';

/// Raw SQL access only — no `Result`, no `Money`, no Domain type crosses
/// this boundary.
@DriftAccessor(tables: [Dreams, DreamMovements])
class DreamDao extends DatabaseAccessor<AppDatabase> with _$DreamDaoMixin {
  DreamDao(super.db);

  Stream<List<DreamRow>> watchActive() {
    return (select(dreams)
          ..where((d) => d.status.isNotIn(const ['archived', 'cancelled']))
          ..orderBy([(d) => OrderingTerm.desc(d.createdAt)]))
        .watch();
  }

  Future<DreamRow?> findById(String id) {
    return (select(dreams)..where((d) => d.id.equals(id))).getSingleOrNull();
  }

  Stream<DreamRow?> watchById(String id) {
    return (select(dreams)..where((d) => d.id.equals(id))).watchSingleOrNull();
  }

  Future<void> insertDream(DreamRow row) => into(dreams).insert(row);

  Future<void> updateDream(DreamRow row) => update(dreams).replace(row);

  Stream<List<DreamMovementRow>> watchMovements(String dreamId) {
    return (select(dreamMovements)
          ..where((m) => m.dreamId.equals(dreamId))
          ..orderBy([(m) => OrderingTerm.desc(m.date)]))
        .watch();
  }

  Future<void> insertMovement(DreamMovementRow row) => into(dreamMovements).insert(row);

  /// Inserts the movement and persists the Dream's new state in one
  /// atomic transaction — the two must never be observed out of sync.
  Future<void> recordMovement(DreamMovementRow movement, DreamRow updatedDream) {
    return transaction(() async {
      await insertMovement(movement);
      await updateDream(updatedDream);
    });
  }
}
