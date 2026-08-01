import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_providers.dart';
import '../../../../services/database/daos/subscription_dao.dart';
import '../../../transactions/presentation/controllers/transaction_providers.dart';
import '../../application/usecases/confirm_subscription_usecase.dart';
import '../../application/usecases/detect_subscription_suggestions_usecase.dart';
import '../../application/usecases/update_subscription_status_usecase.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../infrastructure/repositories/drift_subscription_repository.dart';

final subscriptionDaoProvider = Provider<SubscriptionDao>((ref) {
  return ref.watch(appDatabaseProvider).subscriptionDao;
});

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return DriftSubscriptionRepository(
    ref.watch(subscriptionDaoProvider),
    ref.watch(idGeneratorProvider),
    ref.watch(clockProvider),
  );
});

final detectSubscriptionSuggestionsUseCaseProvider =
    Provider<DetectSubscriptionSuggestionsUseCase>((ref) {
  return DetectSubscriptionSuggestionsUseCase(
    ref.watch(transactionRepositoryProvider),
    ref.watch(subscriptionRepositoryProvider),
  );
});

final confirmSubscriptionUseCaseProvider = Provider<ConfirmSubscriptionUseCase>((ref) {
  return ConfirmSubscriptionUseCase(ref.watch(subscriptionRepositoryProvider));
});

final updateSubscriptionStatusUseCaseProvider = Provider<UpdateSubscriptionStatusUseCase>((ref) {
  return UpdateSubscriptionStatusUseCase(ref.watch(subscriptionRepositoryProvider));
});

final subscriptionsStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(subscriptionRepositoryProvider).watchAll();
});

/// One-shot — recomputed each time the Subscriptions page (re)mounts,
/// same shape as `dashboardSummaryProvider`.
final subscriptionSuggestionsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(detectSubscriptionSuggestionsUseCaseProvider).call();
});
