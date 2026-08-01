import '../../../../shared/models/money.dart';
import 'subscription_frequency.dart';

/// A recurring-payment pattern found in Transaction history — never
/// persisted. `docs/02-Domain/08-Subscriptions.md`: "Subscriptions are
/// inferred. Never assumed." — confirming one is what turns it into a
/// real [Subscription].
class SubscriptionSuggestion {
  const SubscriptionSuggestion({
    required this.merchant,
    required this.averageAmount,
    required this.frequency,
    required this.occurrenceCount,
    required this.lastTransactionDate,
    required this.confidenceScore,
  });

  final String merchant;
  final Money averageAmount;
  final SubscriptionFrequency frequency;
  final int occurrenceCount;
  final DateTime lastTransactionDate;

  /// 0-100, same shape as Weaver's confidence model — this detector is
  /// rule-based, not AI, but the concept ("how sure are we?") is the same.
  final int confidenceScore;
}
