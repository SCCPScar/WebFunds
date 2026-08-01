import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/result/result.dart';
import 'package:webfunds/features/subscriptions/application/usecases/detect_subscription_suggestions_usecase.dart';
import 'package:webfunds/features/subscriptions/domain/entities/subscription.dart';
import 'package:webfunds/features/subscriptions/domain/entities/subscription_frequency.dart';
import 'package:webfunds/features/subscriptions/domain/entities/subscription_status.dart';
import 'package:webfunds/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction_type.dart';
import 'package:webfunds/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:webfunds/shared/models/money.dart';

class _StubTransactionRepository implements TransactionRepository {
  _StubTransactionRepository(this._transactions);
  final List<Transaction> _transactions;

  @override
  Future<Result<List<Transaction>>> getAll() async => Success(_transactions);

  @override
  Future<Result<Transaction?>> getById(String id) => throw UnimplementedError();

  @override
  Stream<Result<List<Transaction>>> watchByCycle(String financialCycleId) =>
      throw UnimplementedError();

  @override
  Future<Result<Transaction>> create({
    required String financialCycleId,
    required String accountId,
    required TransactionType type,
    required Money amount,
    required DateTime transactionDate,
    String? merchant,
    String? category,
  }) => throw UnimplementedError();

  @override
  Future<Result<Transaction>> updateMerchantAndCategory(
    String id, {
    String? merchant,
    String? category,
  }) => throw UnimplementedError();
}

class _StubSubscriptionRepository implements SubscriptionRepository {
  _StubSubscriptionRepository([this._existing = const []]);
  final List<Subscription> _existing;

  @override
  Future<Result<List<Subscription>>> getAll() async => Success(_existing);

  @override
  Stream<Result<List<Subscription>>> watchAll() => throw UnimplementedError();

  @override
  Future<Result<Subscription>> create({
    required String merchant,
    required Money expectedAmount,
    required SubscriptionFrequency frequency,
    DateTime? nextExpectedDate,
    String? category,
  }) => throw UnimplementedError();

  @override
  Future<Result<Subscription>> updateStatus(String id, SubscriptionStatus status) =>
      throw UnimplementedError();
}

Transaction _expense(String merchant, double amount, DateTime date) {
  return Transaction(
    id: '$merchant-$date',
    financialCycleId: 'cycle-1',
    accountId: 'account-1',
    type: TransactionType.expense,
    amount: Money.fromMajorUnits(amount),
    transactionDate: date,
    merchant: merchant,
    createdAt: date,
    updatedAt: date,
  );
}

void main() {
  test('detects a monthly subscription from three regular, same-amount payments', () async {
    final transactions = [
      _expense('Netflix', 12.99, DateTime(2026, 1, 5)),
      _expense('Netflix', 12.99, DateTime(2026, 2, 5)),
      _expense('Netflix', 12.99, DateTime(2026, 3, 6)),
    ];
    final useCase = DetectSubscriptionSuggestionsUseCase(
      _StubTransactionRepository(transactions),
      _StubSubscriptionRepository(),
    );

    final result = await useCase();

    expect(result.isSuccess, isTrue);
    final suggestions = result.dataOrNull!;
    expect(suggestions.length, 1);
    expect(suggestions.first.merchant, 'Netflix');
    expect(suggestions.first.frequency, SubscriptionFrequency.monthly);
    expect(suggestions.first.occurrenceCount, 3);
    expect(suggestions.first.confidenceScore, greaterThan(0));
  });

  test('ignores a merchant with only one purchase', () async {
    final transactions = [_expense('Padaria', 3.5, DateTime(2026, 1, 5))];
    final useCase = DetectSubscriptionSuggestionsUseCase(
      _StubTransactionRepository(transactions),
      _StubSubscriptionRepository(),
    );

    final result = await useCase();

    expect(result.dataOrNull, isEmpty);
  });

  test('ignores wildly varying amounts even at a regular interval', () async {
    final transactions = [
      _expense('Continente', 20, DateTime(2026, 1, 5)),
      _expense('Continente', 80, DateTime(2026, 2, 5)),
      _expense('Continente', 15, DateTime(2026, 3, 5)),
    ];
    final useCase = DetectSubscriptionSuggestionsUseCase(
      _StubTransactionRepository(transactions),
      _StubSubscriptionRepository(),
    );

    final result = await useCase();

    expect(result.dataOrNull, isEmpty);
  });

  test('ignores a regular interval that matches no recognized frequency (~50 days)', () async {
    final transactions = [
      _expense('Restaurante', 25, DateTime(2026, 1, 1)),
      _expense('Restaurante', 25, DateTime(2026, 2, 20)),
      _expense('Restaurante', 25, DateTime(2026, 4, 11)),
    ];
    final useCase = DetectSubscriptionSuggestionsUseCase(
      _StubTransactionRepository(transactions),
      _StubSubscriptionRepository(),
    );

    final result = await useCase();

    expect(result.dataOrNull, isEmpty);
  });

  test('excludes a merchant that already has a confirmed Subscription', () async {
    final transactions = [
      _expense('Spotify', 6.99, DateTime(2026, 1, 5)),
      _expense('Spotify', 6.99, DateTime(2026, 2, 5)),
    ];
    final existing = Subscription(
      id: 'sub-1',
      merchant: 'Spotify',
      expectedAmount: Money.fromMajorUnits(6.99),
      frequency: SubscriptionFrequency.monthly,
      status: SubscriptionStatus.active,
      createdAt: DateTime(2026, 1, 5),
      updatedAt: DateTime(2026, 1, 5),
    );
    final useCase = DetectSubscriptionSuggestionsUseCase(
      _StubTransactionRepository(transactions),
      _StubSubscriptionRepository([existing]),
    );

    final result = await useCase();

    expect(result.dataOrNull, isEmpty);
  });

  test('ignores income and transactions without a merchant', () async {
    final transactions = [
      Transaction(
        id: 'income-1',
        financialCycleId: 'cycle-1',
        accountId: 'account-1',
        type: TransactionType.income,
        amount: Money.fromMajorUnits(1000),
        transactionDate: DateTime(2026, 1, 1),
        merchant: 'Empregador',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
      Transaction(
        id: 'expense-no-merchant',
        financialCycleId: 'cycle-1',
        accountId: 'account-1',
        type: TransactionType.expense,
        amount: Money.fromMajorUnits(10),
        transactionDate: DateTime(2026, 1, 2),
        createdAt: DateTime(2026, 1, 2),
        updatedAt: DateTime(2026, 1, 2),
      ),
    ];
    final useCase = DetectSubscriptionSuggestionsUseCase(
      _StubTransactionRepository(transactions),
      _StubSubscriptionRepository(),
    );

    final result = await useCase();

    expect(result.dataOrNull, isEmpty);
  });
}
