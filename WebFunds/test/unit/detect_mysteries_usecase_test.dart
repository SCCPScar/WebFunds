import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/utils/clock.dart';
import 'package:webfunds/core/utils/id_generator.dart';
import 'package:webfunds/features/mysteries/application/usecases/detect_mysteries_usecase.dart';
import 'package:webfunds/features/mysteries/domain/entities/mystery_reason.dart';
import 'package:webfunds/features/mysteries/infrastructure/repositories/drift_mystery_repository.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction_type.dart';
import 'package:webfunds/features/transactions/infrastructure/repositories/drift_transaction_repository.dart';
import 'package:webfunds/services/database/app_database.dart';
import 'package:webfunds/shared/models/money.dart';

class _SequentialIdGenerator implements IdGenerator {
  int _counter = 0;
  @override
  String generate() => 'mystery-test-id-${_counter++}';
}

class _FixedClock implements Clock {
  const _FixedClock(this._fixed);
  final DateTime _fixed;
  @override
  DateTime now() => _fixed;
}

void main() {
  late AppDatabase database;
  late DriftTransactionRepository transactionRepository;
  late DriftMysteryRepository mysteryRepository;
  late DetectMysteriesUseCase useCase;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    transactionRepository = DriftTransactionRepository(
      database.transactionDao,
      _SequentialIdGenerator(),
      _FixedClock(DateTime(2026, 1, 1)),
    );
    mysteryRepository = DriftMysteryRepository(
      database.mysteryDao,
      _SequentialIdGenerator(),
      _FixedClock(DateTime(2026, 1, 1)),
    );
    useCase = DetectMysteriesUseCase(transactionRepository, mysteryRepository);
  });

  tearDown(() => database.close());

  test('flags an expense with no merchant as Unknown Merchant', () async {
    await transactionRepository.create(
      financialCycleId: 'cycle-1',
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(20),
      transactionDate: DateTime(2026, 1, 5),
    );

    final result = await useCase();

    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull!.length, 1);
    expect(result.dataOrNull!.first.reason, MysteryReason.unknownMerchant);
  });

  test('flags an expense with a merchant but no category as Unknown Category', () async {
    await transactionRepository.create(
      financialCycleId: 'cycle-1',
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(20),
      transactionDate: DateTime(2026, 1, 5),
      merchant: 'Continente',
    );

    final result = await useCase();

    expect(result.dataOrNull!.first.reason, MysteryReason.unknownCategory);
  });

  test('does not flag a fully-categorized expense', () async {
    await transactionRepository.create(
      financialCycleId: 'cycle-1',
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(20),
      transactionDate: DateTime(2026, 1, 5),
      merchant: 'Continente',
      category: 'Groceries',
    );

    final result = await useCase();

    expect(result.dataOrNull, isEmpty);
  });

  test('does not flag income', () async {
    await transactionRepository.create(
      financialCycleId: 'cycle-1',
      accountId: 'account-1',
      type: TransactionType.income,
      amount: Money.fromMajorUnits(1000),
      transactionDate: DateTime(2026, 1, 5),
    );

    final result = await useCase();

    expect(result.dataOrNull, isEmpty);
  });

  test('running detection twice does not create duplicate Mysteries', () async {
    await transactionRepository.create(
      financialCycleId: 'cycle-1',
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(20),
      transactionDate: DateTime(2026, 1, 5),
    );

    await useCase();
    final second = await useCase();

    expect(second.dataOrNull, isEmpty);
    final all = await mysteryRepository.getAll();
    expect(all.dataOrNull!.length, 1);
  });
}
