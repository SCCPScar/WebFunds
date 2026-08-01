import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/repositories/linked_bank_account_repository.dart';

class UnlinkBankAccountUseCase extends UseCase<void, String> {
  const UnlinkBankAccountUseCase(this._repository);

  final LinkedBankAccountRepository _repository;

  @override
  Future<Result<void>> call(String accountId) => _repository.unlink(accountId);
}
