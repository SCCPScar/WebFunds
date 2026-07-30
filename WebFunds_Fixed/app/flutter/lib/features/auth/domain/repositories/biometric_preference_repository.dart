import '../../../../core/result/result.dart';

abstract class BiometricPreferenceRepository {
  Future<Result<bool>> isBiometricEnabled();
  Future<Result<void>> setBiometricEnabled(bool enabled);
}
