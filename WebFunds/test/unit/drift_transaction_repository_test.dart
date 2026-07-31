import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/result/result.dart';
import 'package:webfunds/core/utils/clock.dart';
import 'package:webfunds/core/utils/id_generator.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction_type.dart';
import 'package:webfunds/features/transactions/infrastructure/repositories/drift_transaction_repository.dart';
import 'package:webfunds/services/database/app_database.dart';
import 'package:webfunds/shared/models/money.dart';

class _SequentialIdGenerator implements IdGenerator {
  int _counter = 0;
  @override
  String generate() => 'transaction-test-id-${_counter++}';
}

class _FixedClock implements Clock {
  const _FixedClock(this._fixed);
  final DateTime _fixed;
  @override
  DateTime now() => _fixed;
}

void main() {
  late AppDatabase database;
  late DriftTransactionRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftTransactionRepository(
      database.transactionDao,
      _SequentialIdGenerator(),
      _FixedClock(DateTime(2026, 1, 1)),
    );
  });

  tearDown(() => database.close());

  test('create persists a transaction with a generated id and the injected clock', () async {
    final result = await repository.create(
      financialCycleId: 'cycle-1',
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(50),
      transactionDate: DateTime(2026, 1, 5),
      merchant: 'Continente',
      category: 'Groceries',
    );

    expect(result.isSuccess, isTrue);
    final transaction = result.dataOrNull!;
    expect(transaction.id, 'transaction-test-id-0');
    expect(transaction.financialCycleId, 'cycle-1');
    expect(transaction.accountId, 'account-1');
    expect(transaction.type, TransactionType.expense);
    expect(transaction.amount, Money.fromMajorUnits(50));
    expect(transaction.merchant, 'Continente');
    expect(transaction.category, 'Groceries');
    expect(transaction.createdAt, DateTime(2026, 1, 1));
    expect(transaction.updatedAt, DateTime(2026, 1, 1));
  });

  test('watchByCycle only emits transactions for the given cycle, newest first', () async {
    await repository.create(
      financialCycleId: 'cycle-1',
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(10),
      transactionDate: DateTime(2026, 1, 1),
    );
    await repository.create(
      financialCycleId: 'cycle-1',
      accountId: 'account-1',
      type: TransactionType.income,
      amount: Money.fromMajorUnits(20),
      transactionDate: DateTime(2026, 1, 10),
    );
    await repository.create(
      financialCycleId: 'cycle-2',
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(30),
      transactionDate: DateTime(2026, 1, 15),
    );

    final result = await repository.watchByCycle('cycle-1').first;
    expect(result.isSuccess, isTrue);
    final transactions = result.dataOrNull!;
    expect(transactions.length, 2);
    expect(transactions.first.amount, Money.fromMajorUnits(20));
    expect(transactions.last.amount, Money.fromMajorUnits(10));
  });

  test('updateMerchantAndCategory changes only merchant/category, keeping other fields',
      () async {
    final created = await repository.create(
      financialCycleId: 'cycle-1',
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(50),
      transactionDate: DateTime(2026, 1, 5),
      merchant: 'Old merchant',
    );
    final transaction = created.dataOrNull!;

    final updated = await repository.updateMerchantAndCategory(
      transaction.id,
      merchant: 'New merchant',
      category: 'Dining',
    );

    expect(updated.isSuccess, isTrue);
    final result = updated.dataOrNull!;
    expect(result.merchant, 'New merchant');
    expect(result.category, 'Dining');
    expect(result.amount, transaction.amount);
    expect(result.transactionDate, transaction.transactionDate);
    expect(result.type, transaction.type);
  });

  test('updateMerchantAndCategory fails validation when the transaction does not exist',
      () async {
    final result =
        await repository.updateMerchantAndCategory('does-not-exist', merchant: 'X');
    expect(result.isError, isTrue);
  });
}
