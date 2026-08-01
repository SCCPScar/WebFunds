import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../services/storage/secure_storage_service.dart';
import '../../domain/repositories/onboarding_repository.dart';

class SecureStorageOnboardingRepository implements OnboardingRepository {
  const SecureStorageOnboardingRepository(this._storage);

  final SecureStorageService _storage;

  static const _key = 'onboarding_complete';

  @override
  Future<Result<bool>> isComplete() async {
    try {
      final value = await _storage.read(key: _key);
      return Success(value == 'true');
    } on AppException catch (e) {
      return ResultError(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void>> markComplete() async {
    try {
      await _storage.write(key: _key, value: 'true');
      return const Success(null);
    } on AppException catch (e) {
      return ResultError(mapExceptionToFailure(e));
    }
  }
}
