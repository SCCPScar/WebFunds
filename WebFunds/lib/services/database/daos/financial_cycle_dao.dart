import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/financial_cycles_table.dart';

part 'financial_cycle_dao.g.dart';

/// Raw SQL access only — no `Result`, no `Money`, no Domain type crosses
/// this boundary. The `'active'` literal below must match
/// `FinancialCycleStatus.active.name` exactly — the DAO deliberately
/// doesn't import the Domain enum to avoid crossing that boundary.
@DriftAccessor(tables: [FinancialCycles])
class FinancialCycleDao extends DatabaseAccessor<AppDatabase> with _$FinancialCycleDaoMixin {
  FinancialCycleDao(super.db);

  Stream<FinancialCycleRow?> watchActive() {
    return (select(financialCycles)..where((c) => c.status.equals('active'))).watchSingleOrNull();
  }

  Future<FinancialCycleRow?> findActive() {
    return (select(financialCycles)..where((c) => c.status.equals('active'))).getSingleOrNull();
  }

  Future<void> insertRow(FinancialCycleRow row) => into(financialCycles).insert(row);

  Future<void> updateRow(FinancialCycleRow row) => update(financialCycles).replace(row);
}
