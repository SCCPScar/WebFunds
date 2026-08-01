import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/repositories/onboarding_repository.dart';

class GetOnboardingCompleteUseCase extends UseCase<bool, NoParams> {
  const GetOnboardingCompleteUseCase(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Result<bool>> call(NoParams params) => _repository.isComplete();
}
