import '../../domain/entities/subscription_status.dart';

extension SubscriptionStatusPresentation on SubscriptionStatus {
  String get label => switch (this) {
    SubscriptionStatus.active => 'Ativa',
    SubscriptionStatus.paused => 'Pausada',
    SubscriptionStatus.cancelled => 'Cancelada',
    SubscriptionStatus.archived => 'Arquivada',
  };
}
