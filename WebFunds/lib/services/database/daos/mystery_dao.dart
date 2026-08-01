import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/mysteries_table.dart';

part 'mystery_dao.g.dart';

/// Raw SQL access only — no `Result`, no Domain type crosses this
/// boundary.
@DriftAccessor(tables: [Mysteries])
class MysteryDao extends DatabaseAccessor<AppDatabase> with _$MysteryDaoMixin {
  MysteryDao(super.db);

  Stream<List<MysteryRow>> watchAll() {
    return (select(mysteries)..orderBy([(m) => OrderingTerm.desc(m.createdAt)])).watch();
  }

  Future<List<MysteryRow>> getAll() => select(mysteries).get();

  Future<MysteryRow?> findById(String id) {
    return (select(mysteries)..where((m) => m.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(MysteryRow row) => into(mysteries).insert(row);

  Future<void> updateRow(MysteryRow row) => update(mysteries).replace(row);
}
