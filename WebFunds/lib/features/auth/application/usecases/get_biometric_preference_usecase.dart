import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/repositories/biometric_preference_repository.dart';

class GetBiometricPreferenceUseCase extends UseCase<bool, NoParams> {
  const GetBiometricPreferenceUseCase(this._repository);

  final BiometricPreferenceRepository _repository;

  @override
  Future<Result<bool>> call(NoParams params) => _repository.isBiometricEnabled();
}