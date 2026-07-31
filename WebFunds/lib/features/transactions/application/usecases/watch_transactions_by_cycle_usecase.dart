import '../../../../core/result/result.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class WatchTransactionsByCycleUseCase {
  const WatchTransactionsByCycleUseCase(this._repository);

  final TransactionRepository _repository;

  Stream<Result<List<Transaction>>> call(String financialCycleId) {
    return _repository.watchByCycle(financialCycleId);
  }
}
