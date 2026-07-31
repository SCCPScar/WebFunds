import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/financial_cycle.dart';
import '../../domain/repositories/financial_cycle_repository.dart';

class CloseFinancialCycleParams {
  const CloseFinancialCycleParams({required this.id, required this.closingBalance});

  final String id;
  final Money closingBalance;
}

class CloseFinancialCycleUseCase extends UseCase<FinancialCycle, CloseFinancialCycleParams> {
  const CloseFinancialCycleUseCase(this._repository);

  final FinancialCycleRepository _repository;

  @override
  Future<Result<FinancialCycle>> call(CloseFinancialCycleParams params) {
    return _repository.close(params.id, closingBalance: params.closingBalance);
  }
}
