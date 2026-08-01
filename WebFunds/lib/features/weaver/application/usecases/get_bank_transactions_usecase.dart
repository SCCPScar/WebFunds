import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/repositories/bank_repository.dart';

class GetBankTransactionsUseCase extends UseCase<List<BankTransaction>, String> {
  const GetBankTransactionsUseCase(this._repository);

  final BankRepository _repository;

  @override
  Future<Result<List<BankTransaction>>> call(String bankAccountId) {
    return _repository.fetchTransactions(bankAccountId);
  }
}
