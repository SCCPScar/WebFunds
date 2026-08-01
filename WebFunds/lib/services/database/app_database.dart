import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/account_dao.dart';
import 'daos/dream_dao.dart';
import 'daos/financial_cycle_dao.dart';
import 'daos/memory_dao.dart';
import 'daos/mystery_dao.dart';
import 'daos/subscription_dao.dart';
import 'daos/transaction_dao.dart';
import 'local_database_service.dart';
import 'tables/accounts_table.dart';
import 'tables/dream_movements_table.dart';
import 'tables/dreams_table.dart';
import 'tables/financial_cycles_table.dart';
import 'tables/memories_table.dart';
import 'tables/mysteries_table.dart';
import 'tables/subscriptions_table.dart';
import 'tables/transactions_table.dart';

part 'app_database.g.dart';

/// WebFunds' local database. Implements `LocalDatabaseService`.
@DriftDatabase(
  tables: [
    Accounts,
    FinancialCycles,
    Transactions,
    Dreams,
    DreamMovements,
    Subscriptions,
    Mysteries,
    Memories,
  ],
  daos: [
    AccountDao,
    FinancialCycleDao,
    TransactionDao,
    DreamDao,
    SubscriptionDao,
    MysteryDao,
    MemoryDao,
  ],
)
class AppDatabase extends _$AppDatabase implements LocalDatabaseService {
  AppDatabase() : super(_openConnection());

  /// Test-only constructor — injects an in-memory connection directly.
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 7;

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
      if (from < 4) {
        await m.createTable(dreams);
        await m.createTable(dreamMovements);
      }
      if (from < 5) {
        await m.createTable(subscriptions);
      }
      if (from < 6) {
        await m.createTable(mysteries);
      }
      if (from < 7) {
        await m.createTable(memories);
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