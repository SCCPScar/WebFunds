import '../../domain/entities/subscription_frequency.dart';

extension SubscriptionFrequencyPresentation on SubscriptionFrequency {
  String get label => switch (this) {
    SubscriptionFrequency.weekly => 'Semanal',
    SubscriptionFrequency.biweekly => 'Quinzenal',
    SubscriptionFrequency.monthly => 'Mensal',
    SubscriptionFrequency.quarterly => 'Trimestral',
    SubscriptionFrequency.semiannual => 'Semestral',
    SubscriptionFrequency.annual => 'Anual',
    SubscriptionFrequency.custom => 'Personalizada',
  };
}
