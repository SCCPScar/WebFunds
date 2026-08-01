import '../../../../core/result/result.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/subscription_status.dart';
import '../../domain/repositories/subscription_repository.dart';

class UpdateSubscriptionStatusParams {
  const UpdateSubscriptionStatusParams({required this.id, required this.status});

  final String id;
  final SubscriptionStatus status;
}

class UpdateSubscriptionStatusUseCase {
  const UpdateSubscriptionStatusUseCase(this._repository);

  final SubscriptionRepository _repository;

  Future<Result<Subscription>> call(UpdateSubscriptionStatusParams params) {
    return _repository.updateStatus(params.id, params.status);
  }
}
