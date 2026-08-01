import '../../../../shared/models/money.dart';
import 'subscription_frequency.dart';
import 'subscription_status.dart';

/// A confirmed recurring payment — `docs/02-Domain/08-Subscriptions.md`.
/// Only ever created by the owner confirming a [SubscriptionSuggestion];
/// never inserted directly from detection.
class Subscription {
  const Subscription({
    required this.id,
    required this.merchant,
    required this.expectedAmount,
    required this.frequency,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.nextExpectedDate,
    this.category,
    this.notes,
  });

  final String id;
  final String merchant;
  final Money expectedAmount;
  final SubscriptionFrequency frequency;
  final SubscriptionStatus status;
  final DateTime? nextExpectedDate;
  final String? category;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}
