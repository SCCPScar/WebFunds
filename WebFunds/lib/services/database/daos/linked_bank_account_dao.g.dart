// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linked_bank_account_dao.dart';

// ignore_for_file: type=lint
mixin _$LinkedBankAccountDaoMixin on DatabaseAccessor<AppDatabase> {
  $LinkedBankAccountsTable get linkedBankAccounts =>
      attachedDatabase.linkedBankAccounts;
  LinkedBankAccountDaoManager get managers => LinkedBankAccountDaoManager(this);
}

class LinkedBankAccountDaoManager {
  final _$LinkedBankAccountDaoMixin _db;
  LinkedBankAccountDaoManager(this._db);
  $$LinkedBankAccountsTableTableManager get linkedBankAccounts =>
      $$LinkedBankAccountsTableTableManager(
          _db.attachedDatabase, _db.linkedBankAccounts);
}
