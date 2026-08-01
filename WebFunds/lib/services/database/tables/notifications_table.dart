import 'package:drift/drift.dart';

/// `@DataClassName('NotificationRow')` avoids the generated class
/// colliding with the Domain entity `AppNotification` (which is itself
/// named to avoid colliding with Flutter's own `Notification` widget
/// type).
@DataClassName('NotificationRow')
class Notifications extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();
  TextColumn get description => text()();

  /// Stores `NotificationCategory.name` as plain text.
  TextColumn get category => text()();

  /// Stores `NotificationPriority.name` as plain text.
  TextColumn get priority => text()();

  /// Stores `NotificationState.name` as plain text.
  TextColumn get state => text()();

  /// What detection dedupes against — see `AppNotification.sourceKey`.
  TextColumn get sourceKey => text().unique()();

  // Not a `.references()` FK — see `transactions_table`'s FKs for why.
  TextColumn get relatedEntityId => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
