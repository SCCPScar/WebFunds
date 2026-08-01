import 'package:drift/drift.dart';

/// `@DataClassName('MysteryRow')` avoids the generated class colliding
/// with the Domain entity `Mystery`.
@DataClassName('MysteryRow')
class Mysteries extends Table {
  TextColumn get id => text()();

  // Not a `.references()` FK — see `transactions_table`'s FKs for why.
  TextColumn get transactionId => text()();

  /// Stores `MysteryReason.name` as plain text.
  TextColumn get reason => text()();

  /// Stores `MysteryStatus.name` as plain text.
  TextColumn get status => text()();

  TextColumn get notes => text().nullable()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
