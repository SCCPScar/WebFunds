import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/account_dao.dart';
import 'local_database_service.dart';
import 'tables/accounts_table.dart';

part 'app_database.g.dart';

/// WebFunds' local database. Implements `LocalDatabaseService`.
@DriftDatabase(tables: [Accounts], daos: [AccountDao])
class AppDatabase extends _$AppDatabase implements LocalDatabaseService {
  AppDatabase() : super(_openConnection());

  /// Test-only constructor — injects an in-memory connection directly.
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;

  @override
  Future<void> initialize() async {}

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'webfunds');
  }
}