import 'package:drift/drift.dart';

/// `@DataClassName('DreamMovementRow')` avoids the generated class
/// colliding with the Domain entity `DreamMovement`.
@DataClassName('DreamMovementRow')
class DreamMovements extends Table {
  TextColumn get id => text()();

  // Not a `.references()` FK: Drift's resolver doesn't yet emit a real
  // SQL constraint for those in this project (see `transactions_table`'s
  // FKs), so a plain column with the same effective behavior is used
  // instead, without the misleading build-time warning.
  TextColumn get dreamId => text()();

  /// Stores `DreamMovementType.name` as plain text.
  TextColumn get type => text()();

  /// Always positive — direction comes from `type`.
  IntColumn get amountMinorUnits => integer()();
  TextColumn get amountCurrency => text().withDefault(const Constant('€'))();

  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
