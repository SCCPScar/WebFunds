import 'package:drift/drift.dart';

/// `@DataClassName('FinancialCycleRow')` avoids the generated class
/// colliding with the Domain entity `FinancialCycle`.
@DataClassName('FinancialCycleRow')
class FinancialCycles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();

  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();

  /// Stores `FinancialCycleStatus.name` as plain text (e.g. "active").
  /// No Drift-only enum column — that would duplicate the Domain enum.
  TextColumn get status => text()();

  /// Money, always as minor units — never REAL/double.
  IntColumn get openingBalanceMinorUnits => integer()();
  TextColumn get openingBalanceCurrency => text().withDefault(const Constant('€'))();

  IntColumn get closingBalanceMinorUnits => integer().nullable()();
  TextColumn get closingBalanceCurrency => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
