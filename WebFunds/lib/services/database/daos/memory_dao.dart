import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/memories_table.dart';

part 'memory_dao.g.dart';

/// Raw SQL access only — no `Result`, no Domain type crosses this
/// boundary.
@DriftAccessor(tables: [Memories])
class MemoryDao extends DatabaseAccessor<AppDatabase> with _$MemoryDaoMixin {
  MemoryDao(super.db);

  Stream<MemoryRow?> watchByTransactionId(String transactionId) {
    return (select(memories)..where((m) => m.transactionId.equals(transactionId)))
        .watchSingleOrNull();
  }

  Future<MemoryRow?> findByTransactionId(String transactionId) {
    return (select(memories)..where((m) => m.transactionId.equals(transactionId)))
        .getSingleOrNull();
  }

  Future<void> insertRow(MemoryRow row) => into(memories).insert(row);

  Future<void> updateRow(MemoryRow row) => update(memories).replace(row);
}
