import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/errors/failure.dart';
import 'package:webfunds/core/result/result.dart';
import 'package:webfunds/features/transactions/application/usecases/create_transaction_usecase.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction_type.dart';
import 'package:webfunds/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:webfunds/shared/models/money.dart';

class _StubTransactionRepository implements TransactionRepository {
  CreateTransactionParams? lastCreateParams;

  @override
  Stream<Result<List<Transaction>>> watchByCycle(String financialCycleId) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Transaction>>> getAll() {
    throw UnimplementedError();
  }

  @override
  Future<Result<Transaction?>> getById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<Transaction>> create({
    required String financialCycleId,
    required String accountId,
    required TransactionType type,
    required Money amount,
    required DateTime transactionDate,
    String? merchant,
    String? category,
  }) async {
    lastCreateParams = CreateTransactionParams(
      financialCycleId: financialCycleId,
      accountId: accountId,
      type: type,
      amount: amount,
      transactionDate: transactionDate,
      merchant: merchant,
      category: category,
    );
    return Success(
      Transaction(
        id: 'new-transaction',
        financialCycleId: financialCycleId,
        accountId: accountId,
        type: type,
        amount: amount,
        transactionDate: transactionDate,
        merchant: merchant,
        category: category,
        createdAt: transactionDate,
        updatedAt: transactionDate,
      ),
    );
  }

  @override
  Future<Result<Transaction>> updateMerchantAndCategory(
    String id, {
    String? merchant,
    String? category,
  }) async {
    throw UnimplementedError();
  }
}

void main() {
  test('creates a transaction when the amount is positive', () async {
    final repository = _StubTransactionRepository();
    final useCase = CreateTransactionUseCase(repository);

    final result = await useCase(
      CreateTransactionParams(
        financialCycleId: 'cycle-1',
        accountId: 'account-1',
        type: TransactionType.expense,
        amount: Money.fromMajorUnits(50),
        transactionDate: DateTime(2026, 1, 1),
        merchant: '  Continente  ',
        category: '  Groceries  ',
      ),
    );

    expect(result.isSuccess, isTrue);
    expect(repository.lastCreateParams?.merchant, 'Continente');
    expect(repository.lastCreateParams?.category, 'Groceries');
  });

  test('rejects a zero amount', () async {
    final repository = _StubTransactionRepository();
    final useCase = CreateTransactionUseCase(repository);

    final result = await useCase(
      CreateTransactionParams(
        financialCycleId: 'cycle-1',
        accountId: 'account-1',
        type: TransactionType.expense,
        amount: Money.zero(),
        transactionDate: DateTime(2026, 1, 1),
      ),
    );

    expect(result.isError, isTrue);
    expect(result.failureOrNull, isA<ValidationFailure>());
    expect(repository.lastCreateParams, isNull);
  });

  test('treats blank merchant/category as no merchant/category', () async {
    final repository = _StubTransactionRepository();
    final useCase = CreateTransactionUseCase(repository);

    await useCase(
      CreateTransactionParams(
        financialCycleId: 'cycle-1',
        accountId: 'account-1',
        type: TransactionType.income,
        amount: Money.fromMajorUnits(10),
        transactionDate: DateTime(2026, 1, 1),
        merchant: '   ',
        category: '   ',
      ),
    );

    expect(repository.lastCreateParams?.merchant, isNull);
    expect(repository.lastCreateParams?.category, isNull);
  });
}
