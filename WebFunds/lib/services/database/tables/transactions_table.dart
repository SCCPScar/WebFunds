import 'package:drift/drift.dart';

import 'accounts_table.dart';
import 'financial_cycles_table.dart';

/// `@DataClassName('TransactionRow')` avoids the generated class
/// colliding with the Domain entity `Transaction`.
@DataClassName('TransactionRow')
class Transactions extends Table {
  TextColumn get id => text()();

  TextColumn get financialCycleId => text().references(FinancialCycles, #id)();
  TextColumn get accountId => text().references(Accounts, #id)();

  /// Stores `TransactionType.name` as plain text (e.g. "expense"). No
  /// Drift-only enum column — that would duplicate the Domain enum.
  TextColumn get type => text()();

  /// Money, always as minor units, always positive — never REAL/double.
  IntColumn get amountMinorUnits => integer()();
  TextColumn get amountCurrency => text().withDefault(const Constant('€'))();

  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get merchant => text().nullable()();
  TextColumn get category => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
