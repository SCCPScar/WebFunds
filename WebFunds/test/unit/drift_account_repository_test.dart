import 'package:async/async.dart' show StreamQueue;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/result/result.dart';
import 'package:webfunds/core/utils/clock.dart';
import 'package:webfunds/core/utils/id_generator.dart';
import 'package:webfunds/features/accounts/domain/entities/account.dart';
import 'package:webfunds/features/accounts/domain/entities/account_type.dart';
import 'package:webfunds/features/accounts/infrastructure/repositories/drift_account_repository.dart';
import 'package:webfunds/services/database/app_database.dart';
import 'package:webfunds/shared/models/money.dart';

class _SequentialIdGenerator implements IdGenerator {
  int _counter = 0;
  @override
  String generate() => 'test-id-${_counter++}';
}

class _FixedClock implements Clock {
  const _FixedClock(this._fixed);
  final DateTime _fixed;
  @override
  DateTime now() => _fixed;
}

void main() {
  late AppDatabase database;
  late DriftAccountRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftAccountRepository(
      database.accountDao,
      _SequentialIdGenerator(),
      _FixedClock(DateTime(2026, 1, 1)),
    );
  });

  tearDown(() => database.close());

  test('create persists an Account with a generated id and the injected clock', () async {
    final result = await repository.create(
      name: 'Conta Corrente',
      type: AccountType.checking,
      openingBalance: Money.fromMajorUnits(100),
    );

    expect(result.isSuccess, isTrue);
    final account = result.dataOrNull!;
    expect(account.id, 'test-id-0');
    expect(account.createdAt, DateTime(2026, 1, 1));
    expect(account.openingBalance, Money.fromMajorUnits(100));
    expect(account.isArchived, isFalse);
  });

  test('watchAll reacts live: emits empty, then with the account, then without it', () async {
    // A StreamQueue is used instead of expectLater(emitsInOrder(...))
    // because the latter only starts listening asynchronously: racing it
    // against an immediate repository.create() risks the first ("empty")
    // emission arriving after the account was already inserted. Awaiting
    // each `next` before triggering the following write guarantees the
    // subscription is caught up before each mutation happens.
    final queue = StreamQueue<Result<List<Account>>>(repository.watchAll());
    addTearDown(queue.cancel);

    expect((await queue.next).dataOrNull, isEmpty);

    final created = await repository.create(
      name: 'Reativa',
      type: AccountType.checking,
      openingBalance: Money.zero(),
    );
    expect((await queue.next).dataOrNull, hasLength(1));

    await repository.archive(created.dataOrNull!.id);
    expect((await queue.next).dataOrNull, isEmpty);
  });

  test('getById returns null for a non-existent id, never an error', () async {
    final result = await repository.getById('does-not-exist');
    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull, isNull);
  });

  test('update persists changes to name and openingBalance', () async {
    final created = await repository.create(
      name: 'Original',
      type: AccountType.cash,
      openingBalance: Money.zero(),
    );
    final account = created.dataOrNull!;

    await repository.update(
      Account(
        id: account.id,
        name: 'Atualizada',
        type: account.type,
        openingBalance: Money.fromMajorUnits(50),
        createdAt: account.createdAt,
      ),
    );

    final refetched = (await repository.getById(account.id)).dataOrNull!;
    expect(refetched.name, 'Atualizada');
    expect(refetched.openingBalance, Money.fromMajorUnits(50));
  });

  test('money survives a round trip through Drift as minor units, never as double', () async {
    final result = await repository.create(
      name: 'Precisão',
      type: AccountType.checking,
      openingBalance: Money.fromMajorUnits(19.99),
    );
    final refetched = (await repository.getById(result.dataOrNull!.id)).dataOrNull!;

    expect(refetched.openingBalance.minorUnits, 1999);
  });
}
