import 'package:drift/drift.dart';

/// Enable Banking only ever returns Accounts as the result of exchanging
/// a consent code — there's no "list my accounts" call — so the app
/// persists what it got locally, the same way it persists everything
/// else. `id` is the bank's own account uid (Enable Banking's), not a
/// generated one.
@DataClassName('LinkedBankAccountRow')
class LinkedBankAccounts extends Table {
  TextColumn get id => text()();

  TextColumn get institutionName => text()();
  TextColumn get iban => text()();
  TextColumn get displayName => text()();

  DateTimeColumn get linkedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
