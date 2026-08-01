import '../../../../core/result/result.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class GetTransactionByIdUseCase {
  const GetTransactionByIdUseCase(this._repository);

  final TransactionRepository _repository;

  Future<Result<Transaction?>> call(String id) => _repository.getById(id);
}
