import 'package:drift/drift.dart';

/// `@DataClassName('AccountRow')` avoids the generated class colliding
/// with the Domain entity `Account`.
@DataClassName('AccountRow')
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  /// Stores `AccountType.name` as plain text (e.g. "checking"). No Drift
  /// enum column is used here — that would require a Drift-only enum
  /// duplicating `AccountType`, which `AccountMapper` must not depend on.
  TextColumn get type => text()();

  /// Money, always as minor units — never REAL/double.
  IntColumn get openingBalanceMinorUnits => integer()();
  TextColumn get openingBalanceCurrency => text().withDefault(const Constant('€'))();

  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}