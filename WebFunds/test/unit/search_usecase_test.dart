import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/utils/clock.dart';
import 'package:webfunds/core/utils/id_generator.dart';
import 'package:webfunds/features/dreams/infrastructure/repositories/drift_dream_repository.dart';
import 'package:webfunds/features/mysteries/domain/entities/mystery_reason.dart';
import 'package:webfunds/features/mysteries/infrastructure/repositories/drift_mystery_repository.dart';
import 'package:webfunds/features/search/application/usecases/search_usecase.dart';
import 'package:webfunds/features/search/domain/entities/search_result_type.dart';
import 'package:webfunds/features/subscriptions/domain/entities/subscription_frequency.dart';
import 'package:webfunds/features/subscriptions/infrastructure/repositories/drift_subscription_repository.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction_type.dart';
import 'package:webfunds/features/transactions/infrastructure/repositories/drift_transaction_repository.dart';
import 'package:webfunds/services/database/app_database.dart';
import 'package:webfunds/shared/models/money.dart';

class _SequentialIdGenerator implements IdGenerator {
  int _counter = 0;
  @override
  String generate() => 'search-test-id-${_counter++}';
}

class _FixedClock implements Clock {
  const _FixedClock(this._fixed);
  final DateTime _fixed;
  @override
  DateTime now() => _fixed;
}

void main() {
  late AppDatabase database;
  late SearchUseCase useCase;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    final idGenerator = _SequentialIdGenerator();
    final clock = _FixedClock(DateTime(2026, 1, 1));

    final transactionRepository =
        DriftTransactionRepository(database.transactionDao, idGenerator, clock);
    final dreamRepository = DriftDreamRepository(database.dreamDao, idGenerator, clock);
    final mysteryRepository = DriftMysteryRepository(database.mysteryDao, idGenerator, clock);
    final subscriptionRepository =
        DriftSubscriptionRepository(database.subscriptionDao, idGenerator, clock);

    await transactionRepository.create(
      financialCycleId: 'cycle-1',
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(20),
      transactionDate: DateTime(2026, 1, 5),
      merchant: 'Continente',
      category: 'Groceries',
    );
    await dreamRepository.create(name: 'Viagem a Tóquio', targetAmount: Money.fromMajorUnits(1000));
    final tx2 = await transactionRepository.create(
      financialCycleId: 'cycle-1',
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(15),
      transactionDate: DateTime(2026, 1, 6),
    );
    await mysteryRepository.create(
      transactionId: tx2.dataOrNull!.id,
      reason: MysteryReason.unknownMerchant,
      notes: 'Provavelmente Netflix',
    );
    await subscriptionRepository.create(
      merchant: 'Netflix',
      expectedAmount: Money.fromMajorUnits(12),
      frequency: SubscriptionFrequency.monthly,
    );

    useCase = SearchUseCase(
      transactionRepository,
      dreamRepository,
      mysteryRepository,
      subscriptionRepository,
    );
  });

  tearDown(() => database.close());

  test('an empty query returns no results without touching any repository', () async {
    final result = await useCase(const SearchParams(''));

    expect(result.dataOrNull, isEmpty);
  });

  test('matches a Transaction by merchant, case-insensitively', () async {
    final result = await useCase(const SearchParams('continente'));

    expect(result.dataOrNull!.length, 1);
    expect(result.dataOrNull!.first.type, SearchResultType.transaction);
  });

  test('matches a Dream by name', () async {
    final result = await useCase(const SearchParams('tóquio'));

    expect(result.dataOrNull!.length, 1);
    expect(result.dataOrNull!.first.type, SearchResultType.dream);
  });

  test('matches a Mystery by notes and a Subscription by merchant for the same query', () async {
    final result = await useCase(const SearchParams('netflix'));

    final types = result.dataOrNull!.map((r) => r.type).toSet();
    expect(types, {SearchResultType.mystery, SearchResultType.subscription});
  });

  test('a query matching nothing returns an empty list, not an error', () async {
    final result = await useCase(const SearchParams('does-not-exist'));

    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull, isEmpty);
  });
}
