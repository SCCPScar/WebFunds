import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/repositories/biometric_preference_repository.dart';

class SetBiometricPreferenceUseCase extends UseCase<void, bool> {
  const SetBiometricPreferenceUseCase(this._repository);

  final BiometricPreferenceRepository _repository;

  @override
  Future<Result<void>> call(bool params) => _repository.setBiometricEnabled(params);
}