import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/subscription_frequency.dart';
import '../../domain/entities/subscription_suggestion.dart';
import '../../domain/repositories/subscription_repository.dart';

class ConfirmSubscriptionParams {
  const ConfirmSubscriptionParams({required this.suggestion, this.category});

  final SubscriptionSuggestion suggestion;
  final String? category;
}

/// Turns a computed [SubscriptionSuggestion] into a real, persisted
/// [Subscription] — the only way one is ever created, per
/// `docs/02-Domain/08-Subscriptions.md`: "always confirmed by the owner."
class ConfirmSubscriptionUseCase extends UseCase<Subscription, ConfirmSubscriptionParams> {
  const ConfirmSubscriptionUseCase(this._repository);

  final SubscriptionRepository _repository;

  @override
  Future<Result<Subscription>> call(ConfirmSubscriptionParams params) {
    final suggestion = params.suggestion;
    return _repository.create(
      merchant: suggestion.merchant,
      expectedAmount: suggestion.averageAmount,
      frequency: suggestion.frequency,
      nextExpectedDate: _nextExpectedDate(suggestion),
      category: params.category,
    );
  }

  DateTime _nextExpectedDate(SubscriptionSuggestion suggestion) {
    return suggestion.lastTransactionDate.add(
      Duration(days: suggestion.frequency.approximateDays),
    );
  }
}
