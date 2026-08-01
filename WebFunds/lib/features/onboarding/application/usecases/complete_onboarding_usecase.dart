import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase extends UseCase<void, NoParams> {
  const CompleteOnboardingUseCase(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) => _repository.markComplete();
}
