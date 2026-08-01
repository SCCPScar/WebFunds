import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/storage/secure_storage_service.dart';
import '../../application/usecases/complete_onboarding_usecase.dart';
import '../../application/usecases/get_onboarding_complete_usecase.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../infrastructure/repositories/secure_storage_onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return SecureStorageOnboardingRepository(ref.watch(secureStorageServiceProvider));
});

final getOnboardingCompleteUseCaseProvider = Provider<GetOnboardingCompleteUseCase>((ref) {
  return GetOnboardingCompleteUseCase(ref.watch(onboardingRepositoryProvider));
});

final completeOnboardingUseCaseProvider = Provider<CompleteOnboardingUseCase>((ref) {
  return CompleteOnboardingUseCase(ref.watch(onboardingRepositoryProvider));
});

/// The router's `redirect` and `refreshListenable` both read/watch this —
/// set once by `AuthGateController` when startup resolves (from
/// `StartupResult.onboardingComplete`), and again by `OnboardingPage`'s
/// Finish step once `CompleteOnboardingUseCase` succeeds. Defaults `true`
/// (no gate) so nothing redirects to Onboarding before startup has had a
/// chance to say otherwise.
class OnboardingCompleteNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void set(bool value) => state = value;
}

final onboardingCompleteProvider = NotifierProvider<OnboardingCompleteNotifier, bool>(
  OnboardingCompleteNotifier.new,
);
