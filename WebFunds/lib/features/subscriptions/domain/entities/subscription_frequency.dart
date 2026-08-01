/// `docs/02-Domain/08-Subscriptions.md` Frequencies. `custom` exists in
/// the schema for a future manual-frequency flow; v1's detector only
/// ever infers one of the other six from the gap between Transactions.
enum SubscriptionFrequency { weekly, biweekly, monthly, quarterly, semiannual, annual, custom }

extension SubscriptionFrequencyIntervalDays on SubscriptionFrequency {
  int get approximateDays => switch (this) {
    SubscriptionFrequency.weekly => 7,
    SubscriptionFrequency.biweekly => 14,
    SubscriptionFrequency.monthly => 30,
    SubscriptionFrequency.quarterly => 91,
    SubscriptionFrequency.semiannual => 182,
    SubscriptionFrequency.annual => 365,
    SubscriptionFrequency.custom => 30,
  };
}
