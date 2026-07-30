import '../../../../shared/models/money.dart';
import 'account_type.dart';

/// A financial Account. Deliberately small — new concepts (limits, cards,
/// institutions, ...) get their own models when they gain real content,
/// never folded in here.
class Account {
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.openingBalance,
    required this.createdAt,
    this.isArchived = false,
  });

  final String id;
  final String name;
  final AccountType type;

  /// The balance this Account started with — never the current balance.
  /// The current balance is always *derived* (opening balance + this
  /// Account's Transactions), computed by a future Application-layer
  /// UseCase once Transactions exist — never stored here, to avoid two
  /// competing sources of truth.
  final Money openingBalance;

  final DateTime createdAt;
  final bool isArchived;
}