import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/utils/clock.dart';
import 'package:webfunds/core/utils/id_generator.dart';
import 'package:webfunds/features/memories/domain/entities/memory_mood.dart';
import 'package:webfunds/features/memories/infrastructure/repositories/drift_memory_repository.dart';
import 'package:webfunds/services/database/app_database.dart';

class _SequentialIdGenerator implements IdGenerator {
  int _counter = 0;
  @override
  String generate() => 'memory-test-id-${_counter++}';
}

class _FixedClock implements Clock {
  _FixedClock(this._fixed);
  final DateTime _fixed;
  @override
  DateTime now() => _fixed;
}

void main() {
  late AppDatabase database;
  late DriftMemoryRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftMemoryRepository(
      database.memoryDao,
      _SequentialIdGenerator(),
      _FixedClock(DateTime(2026, 1, 1)),
    );
  });

  tearDown(() => database.close());

  test('upsert creates a Memory with a generated id when none exists', () async {
    final result = await repository.upsert(
      transactionId: 'transaction-1',
      title: 'New Laptop',
      narrative: 'Finally bought it.',
      mood: MemoryMood.excited,
      tags: const ['Tech', 'Gift'],
    );

    expect(result.isSuccess, isTrue);
    final memory = result.dataOrNull!;
    expect(memory.id, 'memory-test-id-0');
    expect(memory.title, 'New Laptop');
    expect(memory.mood, MemoryMood.excited);
    expect(memory.tags, ['Tech', 'Gift']);
  });

  test('upsert updates the existing Memory for that Transaction instead of creating another',
      () async {
    final first = await repository.upsert(transactionId: 'transaction-1', title: 'First');
    final second = await repository.upsert(transactionId: 'transaction-1', title: 'Updated');

    expect(second.dataOrNull!.id, first.dataOrNull!.id);
    expect(second.dataOrNull!.title, 'Updated');

    final watched = await repository.watchByTransactionId('transaction-1').first;
    expect(watched.dataOrNull!.title, 'Updated');
  });

  test('watchByTransactionId emits null for a Transaction with no Memory', () async {
    final result = await repository.watchByTransactionId('no-memory').first;

    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull, isNull);
  });

  test('an empty tags list round-trips as empty, not a stray blank tag', () async {
    final result = await repository.upsert(transactionId: 'transaction-1');

    expect(result.dataOrNull!.tags, isEmpty);
  });
}
