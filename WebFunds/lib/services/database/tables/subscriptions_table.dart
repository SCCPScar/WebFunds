import 'package:drift/drift.dart';

/// `@DataClassName('SubscriptionRow')` avoids the generated class
/// colliding with the Domain entity `Subscription`.
@DataClassName('SubscriptionRow')
class Subscriptions extends Table {
  TextColumn get id => text()();
  TextColumn get merchant => text()();

  IntColumn get expectedAmountMinorUnits => integer()();
  TextColumn get expectedAmountCurrency => text().withDefault(const Constant('€'))();

  /// Stores `SubscriptionFrequency.name` as plain text.
  TextColumn get frequency => text()();

  /// Stores `SubscriptionStatus.name` as plain text.
  TextColumn get status => text()();

  DateTimeColumn get nextExpectedDate => dateTime().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
