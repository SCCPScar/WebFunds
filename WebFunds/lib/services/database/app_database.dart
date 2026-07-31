import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/account_dao.dart';
import 'daos/financial_cycle_dao.dart';
import 'daos/transaction_dao.dart';
import 'local_database_service.dart';
import 'tables/accounts_table.dart';
import 'tables/financial_cycles_table.dart';
import 'tables/transactions_table.dart';

part 'app_database.g.dart';

/// WebFunds' local database. Implements `LocalDatabaseService`.
@DriftDatabase(
  tables: [Accounts, FinancialCycles, Transactions],
  daos: [AccountDao, FinancialCycleDao, TransactionDao],
)
class AppDatabase extends _$AppDatabase implements LocalDatabaseService {
  AppDatabase() : super(_openConnection());

  /// Test-only constructor — injects an in-memory connection directly.
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) => m.createAll(),
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(financialCycles);
      }
      if (from < 3) {
        await m.createTable(transactions);
      }
    },
  );

  @override
  Future<void> initialize() async {}

  // `driftDatabase` opens a plain, unencrypted SQLite file — `drift_flutter`
  // has no cipher/password option. At-rest protection for this database
  // relies entirely on the OS's own disk/keystore encryption, not on
  // anything this app does.
  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'webfunds');
  }
}