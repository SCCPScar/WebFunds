import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/use_case.dart';
import '../../../accounts/presentation/controllers/account_providers.dart';
import '../../../transactions/presentation/controllers/transaction_providers.dart';
import '../../application/engine/weaver_engine.dart';
import '../../application/usecases/generate_alerts_usecase.dart';
import '../../application/usecases/generate_insights_usecase.dart';
import '../../application/usecases/generate_recommendations_usecase.dart';

/// DI wiring for `WeaverEngine`'s local financial-intelligence layer —
/// kept in its own file, separate from `weaver_providers.dart` (Weaver AI
/// v1's category-suggestion providers), which stays untouched.
final weaverEngineProvider = Provider<WeaverEngine>((ref) => const WeaverEngine());

final generateInsightsUseCaseProvider = Provider<GenerateInsightsUseCase>((ref) {
  return GenerateInsightsUseCase(
    ref.watch(accountRepositoryProvider),
    ref.watch(transactionRepositoryProvider),
    ref.watch(getAccountBalancesUseCaseProvider),
    ref.watch(weaverEngineProvider),
  );
});

final generateRecommendationsUseCaseProvider = Provider<GenerateRecommendationsUseCase>((ref) {
  return GenerateRecommendationsUseCase(
    ref.watch(accountRepositoryProvider),
    ref.watch(transactionRepositoryProvider),
    ref.watch(getAccountBalancesUseCaseProvider),
    ref.watch(weaverEngineProvider),
  );
});

final generateAlertsUseCaseProvider = Provider<GenerateAlertsUseCase>((ref) {
  return GenerateAlertsUseCase(
    ref.watch(accountRepositoryProvider),
    ref.watch(transactionRepositoryProvider),
    ref.watch(getAccountBalancesUseCaseProvider),
    ref.watch(weaverEngineProvider),
  );
});

final weaverInsightsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(generateInsightsUseCaseProvider).call(const NoParams());
});

final weaverRecommendationsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(generateRecommendationsUseCaseProvider).call(const NoParams());
});

final weaverAlertsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(generateAlertsUseCaseProvider).call(const NoParams());
});
