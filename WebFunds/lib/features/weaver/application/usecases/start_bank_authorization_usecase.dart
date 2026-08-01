import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/repositories/bank_repository.dart';

class StartBankAuthorizationParams {
  const StartBankAuthorizationParams({required this.institution, required this.redirectUrl});

  final BankInstitution institution;
  final String redirectUrl;
}

class StartBankAuthorizationUseCase extends UseCase<Uri, StartBankAuthorizationParams> {
  const StartBankAuthorizationUseCase(this._repository);

  final BankRepository _repository;

  @override
  Future<Result<Uri>> call(StartBankAuthorizationParams params) {
    return _repository.startAuthorization(
      institution: params.institution,
      redirectUrl: params.redirectUrl,
    );
  }
}
