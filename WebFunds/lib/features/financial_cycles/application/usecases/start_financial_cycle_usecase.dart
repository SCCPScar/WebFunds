import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/financial_cycle.dart';
import '../../domain/repositories/financial_cycle_repository.dart';

class StartFinancialCycleParams {
  const StartFinancialCycleParams({
    this.name,
    required this.startDate,
    required this.openingBalance,
  });

  final String? name;
  final DateTime startDate;
  final Money openingBalance;
}

/// Enforces "cycles never overlap" (`docs/02-Domain/01-Financial-Cycles.md`):
/// only one cycle may be Active at a time, so a new one can't start until
/// the current one is closed.
class StartFinancialCycleUseCase extends UseCase<FinancialCycle, StartFinancialCycleParams> {
  const StartFinancialCycleUseCase(this._repository);

  final FinancialCycleRepository _repository;

  @override
  Future<Result<FinancialCycle>> call(StartFinancialCycleParams params) async {
    final activeResult = await _repository.getActive();
    final blockingFailure = activeResult.failureOrNull;
    if (blockingFailure != null) {
      return ResultError(blockingFailure);
    }
    if (activeResult.dataOrNull != null) {
      return const ResultError(
        ValidationFailure(
          message: 'Já existe um ciclo ativo. Fecha-o antes de iniciares um novo.',
        ),
      );
    }

    return _repository.start(
      name: params.name?.trim().isEmpty ?? true ? null : params.name!.trim(),
      startDate: params.startDate,
      openingBalance: params.openingBalance,
    );
  }
}
