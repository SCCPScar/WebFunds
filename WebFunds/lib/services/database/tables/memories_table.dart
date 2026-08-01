import 'package:drift/drift.dart';

/// `@DataClassName('MemoryRow')` avoids the generated class colliding
/// with the Domain entity `Memory`.
@DataClassName('MemoryRow')
class Memories extends Table {
  TextColumn get id => text()();

  // Not a `.references()` FK — see `transactions_table`'s FKs for why.
  // Unique: v1 allows at most one Memory per Transaction.
  TextColumn get transactionId => text().unique()();

  TextColumn get title => text().nullable()();
  TextColumn get narrative => text().nullable()();

  /// Stores `MemoryMood.name` as plain text, nullable — Mood is optional.
  TextColumn get mood => text().nullable()();

  /// Comma-joined — a real join table is unwarranted for a small,
  /// unordered tag list with no per-tag metadata.
  TextColumn get tags => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
