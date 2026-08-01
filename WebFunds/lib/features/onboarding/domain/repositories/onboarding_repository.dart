import '../../../../core/result/result.dart';

/// Whether the person has been through the Onboarding flow —
/// `docs/01-Experience/10-Onboarding.md`. Defaults to not-complete
/// until the "Finish" step explicitly marks it, the same shape
/// `BiometricPreferenceRepository` established.
abstract class OnboardingRepository {
  Future<Result<bool>> isComplete();
  Future<Result<void>> markComplete();
}
