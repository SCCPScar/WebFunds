import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../../application/usecases/start_financial_cycle_usecase.dart';
import '../../domain/entities/financial_cycle.dart';
import 'financial_cycle_providers.dart';

sealed class StartFinancialCycleState {
  const StartFinancialCycleState();
}

final class StartFinancialCycleIdle extends StartFinancialCycleState {
  const StartFinancialCycleIdle();
}

final class StartFinancialCycleLoading extends StartFinancialCycleState {
  const StartFinancialCycleLoading();
}

final class StartFinancialCycleSuccess extends StartFinancialCycleState {
  const StartFinancialCycleSuccess(this.cycle);
  final FinancialCycle cycle;
}

final class StartFinancialCycleFailed extends StartFinancialCycleState {
  const StartFinancialCycleFailed(this.failure);
  final Failure failure;
}

final startFinancialCycleControllerProvider =
    NotifierProvider<StartFinancialCycleController, StartFinancialCycleState>(
  StartFinancialCycleController.new,
);

class StartFinancialCycleController extends Notifier<StartFinancialCycleState> {
  @override
  StartFinancialCycleState build() => const StartFinancialCycleIdle();

  Future<void> submit({
    String? name,
    required DateTime startDate,
    required Money openingBalance,
  }) async {
    state = const StartFinancialCycleLoading();

    final useCase = ref.read(startFinancialCycleUseCaseProvider);
    final result = await useCase(
      StartFinancialCycleParams(name: name, startDate: startDate, openingBalance: openingBalance),
    );

    state = switch (result) {
      Success<FinancialCycle>(:final data) => StartFinancialCycleSuccess(data),
      ResultError<FinancialCycle>(:final failure) => StartFinancialCycleFailed(failure),
    };
  }

  void reset() => state = const StartFinancialCycleIdle();
}
