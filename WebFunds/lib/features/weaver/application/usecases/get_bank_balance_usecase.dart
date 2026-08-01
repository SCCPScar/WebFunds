import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/repositories/bank_repository.dart';

class GetBankBalanceUseCase extends UseCase<BankBalance, String> {
  const GetBankBalanceUseCase(this._repository);

  final BankRepository _repository;

  @override
  Future<Result<BankBalance>> call(String bankAccountId) => _repository.fetchBalance(bankAccountId);
}
