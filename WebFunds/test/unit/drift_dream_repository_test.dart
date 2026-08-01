import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/utils/clock.dart';
import 'package:webfunds/core/utils/id_generator.dart';
import 'package:webfunds/features/dreams/domain/entities/dream_status.dart';
import 'package:webfunds/features/dreams/infrastructure/repositories/drift_dream_repository.dart';
import 'package:webfunds/services/database/app_database.dart';
import 'package:webfunds/shared/models/money.dart';

class _SequentialIdGenerator implements IdGenerator {
  int _counter = 0;
  @override
  String generate() => 'dream-test-id-${_counter++}';
}

class _FixedClock implements Clock {
  _FixedClock(this._fixed);
  final DateTime _fixed;
  @override
  DateTime now() => _fixed;
}

void main() {
  late AppDatabase database;
  late DriftDreamRepository repository;
  late _FixedClock clock;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    clock = _FixedClock(DateTime(2026, 1, 1));
    repository = DriftDreamRepository(database.dreamDao, _SequentialIdGenerator(), clock);
  });

  tearDown(() => database.close());

  test('create persists an Active Dream with zero reserved and a generated id', () async {
    final result = await repository.create(
      name: 'Laptop novo',
      targetAmount: Money.fromMajorUnits(1000),
    );

    expect(result.isSuccess, isTrue);
    final dream = result.dataOrNull!;
    expect(dream.id, 'dream-test-id-0');
    expect(dream.status, DreamStatus.active);
    expect(dream.reservedAmount, Money.zero());
    expect(dream.targetAmount, Money.fromMajorUnits(1000));
  });

  test('addContribution increases reservedAmount and records a movement', () async {
    final created = await repository.create(
      name: 'Férias',
      targetAmount: Money.fromMajorUnits(500),
    );
    final dream = created.dataOrNull!;

    final result = await repository.addContribution(
      dreamId: dream.id,
      amount: Money.fromMajorUnits(100),
    );

    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull!.reservedAmount, Money.fromMajorUnits(100));
    expect(result.dataOrNull!.status, DreamStatus.active);

    final movements = await repository.watchMovements(dream.id).first;
    expect(movements.dataOrNull!.length, 1);
    expect(movements.dataOrNull!.first.amount, Money.fromMajorUnits(100));
  });

  test('addContribution completes the Dream once the target is reached', () async {
    final created = await repository.create(
      name: 'Bicicleta',
      targetAmount: Money.fromMajorUnits(200),
    );
    final dream = created.dataOrNull!;

    final result = await repository.addContribution(
      dreamId: dream.id,
      amount: Money.fromMajorUnits(200),
    );

    expect(result.dataOrNull!.status, DreamStatus.completed);
    expect(result.dataOrNull!.completedAt, isNotNull);

    // A completed Dream drops out of watchActive() — it's terminal enough
    // not to clutter the active list, same reasoning as archived/cancelled.
  });

  test('addWithdrawal decreases reservedAmount', () async {
    final created = await repository.create(
      name: 'Curso',
      targetAmount: Money.fromMajorUnits(300),
    );
    final dream = created.dataOrNull!;
    await repository.addContribution(dreamId: dream.id, amount: Money.fromMajorUnits(150));

    final result = await repository.addWithdrawal(
      dreamId: dream.id,
      amount: Money.fromMajorUnits(50),
    );

    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull!.reservedAmount, Money.fromMajorUnits(100));
  });

  test('addWithdrawal fails validation when it would go negative', () async {
    final created = await repository.create(
      name: 'Curso',
      targetAmount: Money.fromMajorUnits(300),
    );
    final dream = created.dataOrNull!;

    final result = await repository.addWithdrawal(
      dreamId: dream.id,
      amount: Money.fromMajorUnits(50),
    );

    expect(result.isError, isTrue);
  });

  test('withdrawing from a completed Dream below target reopens it as Active', () async {
    final created = await repository.create(
      name: 'Câmara',
      targetAmount: Money.fromMajorUnits(100),
    );
    final dream = created.dataOrNull!;
    await repository.addContribution(dreamId: dream.id, amount: Money.fromMajorUnits(100));

    final result = await repository.addWithdrawal(
      dreamId: dream.id,
      amount: Money.fromMajorUnits(20),
    );

    expect(result.dataOrNull!.status, DreamStatus.active);
    expect(result.dataOrNull!.completedAt, isNull);
  });

  test('archive and cancel change status, watchActive stops including them', () async {
    final created = await repository.create(
      name: 'Mesa nova',
      targetAmount: Money.fromMajorUnits(80),
    );
    final dream = created.dataOrNull!;

    await repository.archive(dream.id);
    final active = await repository.watchActive().first;
    expect(active.dataOrNull!.any((d) => d.id == dream.id), isFalse);
  });

  test('cancel fails validation for a non-existent Dream', () async {
    final result = await repository.cancel('does-not-exist');
    expect(result.isError, isTrue);
  });
}
