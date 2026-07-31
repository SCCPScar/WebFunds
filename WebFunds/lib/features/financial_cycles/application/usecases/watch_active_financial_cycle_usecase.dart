import '../../../../core/result/result.dart';
import '../../domain/entities/financial_cycle.dart';
import '../../domain/repositories/financial_cycle_repository.dart';

class WatchActiveFinancialCycleUseCase {
  const WatchActiveFinancialCycleUseCase(this._repository);

  final FinancialCycleRepository _repository;

  Stream<Result<FinancialCycle?>> call() => _repository.watchActive();
}
