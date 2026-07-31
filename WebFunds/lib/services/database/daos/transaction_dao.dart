import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/transactions_table.dart';

part 'transaction_dao.g.dart';

/// Raw SQL access only — no `Result`, no `Money`, no Domain type crosses
/// this boundary.
@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase> with _$TransactionDaoMixin {
  TransactionDao(super.db);

  Stream<List<TransactionRow>> watchByCycle(String financialCycleId) {
    return (select(transactions)
          ..where((t) => t.financialCycleId.equals(financialCycleId))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .watch();
  }

  Future<TransactionRow?> findById(String id) {
    return (select(transactions)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Every Transaction ever recorded, across every Financial Cycle —
  /// powers derived, always-current Account balances (Dashboard).
  Future<List<TransactionRow>> getAll() => select(transactions).get();

  Future<void> insertRow(TransactionRow row) => into(transactions).insert(row);

  Future<void> updateRow(TransactionRow row) => update(transactions).replace(row);
}
