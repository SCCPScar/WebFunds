import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/errors/failure.dart';
import 'package:webfunds/core/result/result.dart';
import 'package:webfunds/features/financial_cycles/application/usecases/start_financial_cycle_usecase.dart';
import 'package:webfunds/features/financial_cycles/domain/entities/financial_cycle.dart';
import 'package:webfunds/features/financial_cycles/domain/entities/financial_cycle_status.dart';
import 'package:webfunds/features/financial_cycles/domain/repositories/financial_cycle_repository.dart';
import 'package:webfunds/shared/models/money.dart';

class _StubFinancialCycleRepository implements FinancialCycleRepository {
  _StubFinancialCycleRepository({this.active});

  FinancialCycle? active;
  StartFinancialCycleParams? lastStartParams;

  @override
  Future<Result<FinancialCycle?>> getActive() async => Success(active);

  @override
  Stream<Result<FinancialCycle?>> watchActive() => Stream.value(Success(active));

  @override
  Future<Result<FinancialCycle>> start({
    String? name,
    required DateTime startDate,
    required Money openingBalance,
  }) async {
    lastStartParams = StartFinancialCycleParams(
      name: name,
      startDate: startDate,
      openingBalance: openingBalance,
    );
    final created = FinancialCycle(
      id: 'new-cycle',
      name: name,
      startDate: startDate,
      status: FinancialCycleStatus.active,
      openingBalance: openingBalance,
      createdAt: startDate,
      updatedAt: startDate,
    );
    active = created;
    return Success(created);
  }

  @override
  Future<Result<FinancialCycle>> close(String id, {required Money closingBalance}) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<FinancialCycle>>> getAllClosed() async => throw UnimplementedError();
}

FinancialCycle _activeCycle() {
  final now = DateTime(2026, 1, 1);
  return FinancialCycle(
    id: 'existing-active',
    startDate: now,
    status: FinancialCycleStatus.active,
    openingBalance: Money.zero(),
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  test('starts a cycle when none is currently active', () async {
    final repository = _StubFinancialCycleRepository();
    final useCase = StartFinancialCycleUseCase(repository);

    final result = await useCase(
      StartFinancialCycleParams(
        name: '  Fevereiro  ',
        startDate: DateTime(2026, 2, 1),
        openingBalance: Money.fromMajorUnits(200),
      ),
    );

    expect(result.isSuccess, isTrue);
    expect(repository.lastStartParams?.name, 'Fevereiro');
  });

  test('rejects starting a cycle while one is already Active', () async {
    final repository = _StubFinancialCycleRepository(active: _activeCycle());
    final useCase = StartFinancialCycleUseCase(repository);

    final result = await useCase(
      StartFinancialCycleParams(startDate: DateTime(2026, 2, 1), openingBalance: Money.zero()),
    );

    expect(result.isError, isTrue);
    expect(result.failureOrNull, isA<ValidationFailure>());
    expect(repository.lastStartParams, isNull);
  });

  test('treats a blank name the same as no name', () async {
    final repository = _StubFinancialCycleRepository();
    final useCase = StartFinancialCycleUseCase(repository);

    await useCase(
      StartFinancialCycleParams(
        name: '   ',
        startDate: DateTime(2026, 1, 1),
        openingBalance: Money.zero(),
      ),
    );

    expect(repository.lastStartParams?.name, isNull);
  });
}
