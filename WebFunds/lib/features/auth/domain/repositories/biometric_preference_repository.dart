import '../../../../core/result/result.dart';

/// Whether the person has opted into Face ID for daily unlock. Defaults
/// to disabled until a real Profile/Onboarding screen sets it explicitly.
abstract class BiometricPreferenceRepository {
  Future<Result<bool>> isBiometricEnabled();
  Future<Result<void>> setBiometricEnabled(bool enabled);
}