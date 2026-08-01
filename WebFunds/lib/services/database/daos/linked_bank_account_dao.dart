import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/linked_bank_accounts_table.dart';

part 'linked_bank_account_dao.g.dart';

/// Raw SQL access only — no `Result`, no Domain type crosses this
/// boundary.
@DriftAccessor(tables: [LinkedBankAccounts])
class LinkedBankAccountDao extends DatabaseAccessor<AppDatabase> with _$LinkedBankAccountDaoMixin {
  LinkedBankAccountDao(super.db);

  Stream<List<LinkedBankAccountRow>> watchAll() {
    return (select(
      linkedBankAccounts,
    )..orderBy([(a) => OrderingTerm.desc(a.linkedAt)])).watch();
  }

  Future<void> upsert(LinkedBankAccountRow row) {
    return into(linkedBankAccounts).insertOnConflictUpdate(row);
  }

  Future<void> deleteById(String id) {
    return (delete(linkedBankAccounts)..where((a) => a.id.equals(id))).go();
  }
}
