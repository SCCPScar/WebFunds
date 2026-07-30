import 'package:drift/drift.dart';

@DataClassName('AccountRow')
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  IntColumn get openingBalanceMinorUnits => integer()();
  TextColumn get openingBalanceCurrency => text().withDefault(const Constant('€'))();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
