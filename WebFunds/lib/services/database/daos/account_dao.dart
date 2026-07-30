import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/accounts_table.dart';

part 'account_dao.g.dart';

/// Raw SQL access only — no `Result`, no `Money`, no Domain type crosses
/// this boundary.
@DriftAccessor(tables: [Accounts])
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  AccountDao(super.db);

  Stream<List<AccountRow>> watchActive() {
    return (select(accounts)..where((a) => a.isArchived.equals(false))).watch();
  }

  Future<AccountRow?> findById(String id) {
    return (select(accounts)..where((a) => a.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(AccountRow row) => into(accounts).insert(row);

  Future<void> updateRow(AccountRow row) => update(accounts).replace(row);

  Future<void> archiveById(String id) {
    return (update(accounts)..where((a) => a.id.equals(id)))
        .write(const AccountsCompanion(isArchived: Value(true)));
  }
}