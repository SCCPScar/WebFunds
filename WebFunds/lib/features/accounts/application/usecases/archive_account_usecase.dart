import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/repositories/account_repository.dart';

class ArchiveAccountUseCase extends UseCase<void, String> {
  const ArchiveAccountUseCase(this._repository);

  final AccountRepository _repository;

  @override
  Future<Result<void>> call(String accountId) => _repository.archive(accountId);
}