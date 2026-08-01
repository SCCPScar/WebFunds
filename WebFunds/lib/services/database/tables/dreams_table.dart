import 'package:drift/drift.dart';

/// `@DataClassName('DreamRow')` avoids the generated class colliding
/// with the Domain entity `Dream`.
@DataClassName('DreamRow')
class Dreams extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();

  IntColumn get targetAmountMinorUnits => integer()();
  TextColumn get targetAmountCurrency => text().withDefault(const Constant('€'))();

  /// The single source of truth for "how much has been reserved so
  /// far" — never recomputed from the movements table on every read.
  IntColumn get reservedAmountMinorUnits => integer().withDefault(const Constant(0))();
  TextColumn get reservedAmountCurrency => text().withDefault(const Constant('€'))();

  /// Stores `DreamStatus.name` as plain text. No Drift-only enum column
  /// — that would duplicate the Domain enum.
  TextColumn get status => text()();

  TextColumn get category => text().nullable()();
  DateTimeColumn get targetDate => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
