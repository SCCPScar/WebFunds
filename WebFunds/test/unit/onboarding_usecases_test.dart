import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/result/result.dart';
import 'package:webfunds/core/usecase/use_case.dart';
import 'package:webfunds/features/onboarding/application/usecases/complete_onboarding_usecase.dart';
import 'package:webfunds/features/onboarding/application/usecases/get_onboarding_complete_usecase.dart';
import 'package:webfunds/features/onboarding/domain/repositories/onboarding_repository.dart';

class _StubOnboardingRepository implements OnboardingRepository {
  bool complete = false;
  bool markCompleteCalled = false;

  @override
  Future<Result<bool>> isComplete() async => Success(complete);

  @override
  Future<Result<void>> markComplete() async {
    markCompleteCalled = true;
    complete = true;
    return const Success(null);
  }
}

void main() {
  test('GetOnboardingCompleteUseCase forwards the repository value', () async {
    final repository = _StubOnboardingRepository()..complete = true;
    final useCase = GetOnboardingCompleteUseCase(repository);

    final result = await useCase(const NoParams());

    expect(result.dataOrNull, isTrue);
  });

  test('CompleteOnboardingUseCase marks onboarding complete', () async {
    final repository = _StubOnboardingRepository();
    final useCase = CompleteOnboardingUseCase(repository);

    final result = await useCase(const NoParams());

    expect(result.isSuccess, isTrue);
    expect(repository.markCompleteCalled, isTrue);
    expect(repository.complete, isTrue);
  });
}
