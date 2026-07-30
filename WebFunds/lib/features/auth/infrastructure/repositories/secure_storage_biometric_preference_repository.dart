import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../services/storage/secure_storage_service.dart';
import '../../domain/repositories/biometric_preference_repository.dart';

class SecureStorageBiometricPreferenceRepository implements BiometricPreferenceRepository {
  const SecureStorageBiometricPreferenceRepository(this._storage);

  final SecureStorageService _storage;

  static const _key = 'biometric_enabled';

  @override
  Future<Result<bool>> isBiometricEnabled() async {
    try {
      final value = await _storage.read(key: _key);
      return Success(value == 'true');
    } on AppException catch (e) {
      return ResultError(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void>> setBiometricEnabled(bool enabled) async {
    try {
      await _storage.write(key: _key, value: enabled.toString());
      return const Success(null);
    } on AppException catch (e) {
      return ResultError(mapExceptionToFailure(e));
    }
  }
}