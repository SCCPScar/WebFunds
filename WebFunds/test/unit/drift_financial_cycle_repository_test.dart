import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/result/result.dart';
import 'package:webfunds/core/utils/clock.dart';
import 'package:webfunds/core/utils/id_generator.dart';
import 'package:webfunds/features/financial_cycles/domain/entities/financial_cycle.dart';
import 'package:webfunds/features/financial_cycles/domain/entities/financial_cycle_status.dart';
import 'package:webfunds/features/financial_cycles/infrastructure/repositories/drift_financial_cycle_repository.dart';
import 'package:webfunds/services/database/app_database.dart';
import 'package:webfunds/shared/models/money.dart';

class _SequentialIdGenerator implements IdGenerator {
  int _counter = 0;
  @override
  String generate() => 'cycle-test-id-${_counter++}';
}

class _FixedClock implements Clock {
  const _FixedClock(this._fixed);
  final DateTime _fixed;
  @override
  DateTime now() => _fixed;
}

void main() {
  late AppDatabase database;
  late DriftFinancialCycleRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftFinancialCycleRepository(
      database.financialCycleDao,
      _SequentialIdGenerator(),
      _FixedClock(DateTime(2026, 1, 1)),
    );
  });

  tearDown(() => database.close());

  test('getActive returns null when no cycle has ever been started', () async {
    final result = await repository.getActive();
    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull, isNull);
  });

  test('start persists an Active cycle with a generated id and the injected clock', () async {
    final result = await repository.start(
      name: 'Janeiro',
      startDate: DateTime(2026, 1, 1),
      openingBalance: Money.fromMajorUnits(1000),
    );

    expect(result.isSuccess, isTrue);
    final cycle = result.dataOrNull!;
    expect(cycle.id, 'cycle-test-id-0');
    expect(cycle.status, FinancialCycleStatus.active);
    expect(cycle.openingBalance, Money.fromMajorUnits(1000));
    expect(cycle.endDate, isNull);
    expect(cycle.closingBalance, isNull);

    final active = (await repository.getActive()).dataOrNull;
    expect(active?.id, cycle.id);
  });

  test('close moves the cycle to Closed and stamps end date + closing balance', () async {
    final started = await repository.start(
      startDate: DateTime(2026, 1, 1),
      openingBalance: Money.zero(),
    );
    final cycle = started.dataOrNull!;

    final closed = await repository.close(cycle.id, closingBalance: Money.fromMajorUnits(500));

    expect(closed.isSuccess, isTrue);
    final result = closed.dataOrNull!;
    expect(result.status, FinancialCycleStatus.closed);
    expect(result.closingBalance, Money.fromMajorUnits(500));
    expect(result.endDate, DateTime(2026, 1, 1));

    // The closed cycle is no longer the active one.
    expect((await repository.getActive()).dataOrNull, isNull);
  });

  test('close fails validation when the given id is not the current active cycle', () async {
    final result = await repository.close('does-not-exist', closingBalance: Money.zero());
    expect(result.isError, isTrue);
  });

  test('watchActive reacts live: emits null, then the cycle, then null again after closing',
      () async {
    final queue = <Result<FinancialCycle?>>[];
    final subscription = repository.watchActive().listen(queue.add);
    addTearDown(subscription.cancel);

    // Let the initial (empty) emission arrive before mutating.
    await Future<void>.delayed(Duration.zero);
    expect(queue.last.dataOrNull, isNull);

    final started = await repository.start(
      startDate: DateTime(2026, 1, 1),
      openingBalance: Money.zero(),
    );
    await Future<void>.delayed(Duration.zero);
    expect(queue.last.dataOrNull?.id, started.dataOrNull!.id);

    await repository.close(started.dataOrNull!.id, closingBalance: Money.zero());
    await Future<void>.delayed(Duration.zero);
    expect(queue.last.dataOrNull, isNull);
  });

  test('getAllClosed returns only closed cycles, newest first', () async {
    // Two repository instances sharing the same database, each with its
    // own fixed clock, so the two closes get distinct end dates —
    // `getAllClosed()`'s ordering depends on that.
    final earlyRepository = DriftFinancialCycleRepository(
      database.financialCycleDao,
      _SequentialIdGenerator(),
      _FixedClock(DateTime(2026, 1, 15)),
    );
    final lateRepository = DriftFinancialCycleRepository(
      database.financialCycleDao,
      _SequentialIdGenerator(),
      _FixedClock(DateTime(2026, 2, 15)),
    );

    final first = await repository.start(
      startDate: DateTime(2026, 1, 1),
      openingBalance: Money.zero(),
    );
    await earlyRepository.close(first.dataOrNull!.id, closingBalance: Money.zero());

    final second = await repository.start(
      startDate: DateTime(2026, 2, 1),
      openingBalance: Money.zero(),
    );
    await lateRepository.close(second.dataOrNull!.id, closingBalance: Money.zero());

    // Left active — must not appear in getAllClosed().
    await repository.start(startDate: DateTime(2026, 3, 1), openingBalance: Money.zero());

    final result = await repository.getAllClosed();

    expect(result.isSuccess, isTrue);
    final closed = result.dataOrNull!;
    expect(closed.length, 2);
    expect(closed.first.id, second.dataOrNull!.id);
    expect(closed.last.id, first.dataOrNull!.id);
  });
}
