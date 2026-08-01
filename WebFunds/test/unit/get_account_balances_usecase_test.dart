import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/errors/failure.dart';
import 'package:webfunds/core/result/result.dart';
import 'package:webfunds/features/accounts/application/usecases/get_account_balances_usecase.dart';
import 'package:webfunds/features/accounts/domain/entities/account.dart';
import 'package:webfunds/features/accounts/domain/entities/account_type.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction_type.dart';
import 'package:webfunds/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:webfunds/shared/models/money.dart';

class _StubTransactionRepository implements TransactionRepository {
  _StubTransactionRepository(this._result);
  final Result<List<Transaction>> _result;

  @override
  Future<Result<List<Transaction>>> getAll() async => _result;

  @override
  Future<Result<Transaction?>> getById(String id) {
    throw UnimplementedError();
  }

  @override
  Stream<Result<List<Transaction>>> watchByCycle(String financialCycleId) {
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
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Result<Transaction>> updateMerchantAndCategory(
    String id, {
    String? merchant,
    String? category,
  }) {
    throw UnimplementedError();
  }
}

Account _account(String id, double openingBalance) {
  return Account(
    id: id,
    name: 'Conta $id',
    type: AccountType.checking,
    openingBalance: Money.fromMajorUnits(openingBalance),
    createdAt: DateTime(2026, 1, 1),
  );
}

Transaction _transaction(String accountId, TransactionType type, double amount) {
  return Transaction(
    id: 'tx-$accountId-$type-$amount',
    financialCycleId: 'cycle-1',
    accountId: accountId,
    type: type,
    amount: Money.fromMajorUnits(amount),
    transactionDate: DateTime(2026, 1, 5),
    createdAt: DateTime(2026, 1, 5),
    updatedAt: DateTime(2026, 1, 5),
  );
}

void main() {
  test('income adds and expense subtracts from the opening balance', () async {
    final account = _account('a1', 100);
    final useCase = GetAccountBalancesUseCase(
      _StubTransactionRepository(
        Success([
          _transaction('a1', TransactionType.income, 50),
          _transaction('a1', TransactionType.expense, 20),
        ]),
      ),
    );

    final result = await useCase([account]);

    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull!['a1'], Money.fromMajorUnits(130));
  });

  test('transfers do not change the balance', () async {
    final account = _account('a1', 100);
    final useCase = GetAccountBalancesUseCase(
      _StubTransactionRepository(Success([_transaction('a1', TransactionType.transfer, 50)])),
    );

    final result = await useCase([account]);

    expect(result.dataOrNull!['a1'], Money.fromMajorUnits(100));
  });

  test("a transaction for another account doesn't affect this one", () async {
    final account = _account('a1', 100);
    final useCase = GetAccountBalancesUseCase(
      _StubTransactionRepository(Success([_transaction('a2', TransactionType.income, 999)])),
    );

    final result = await useCase([account]);

    expect(result.dataOrNull!['a1'], Money.fromMajorUnits(100));
  });

  test('propagates a repository failure', () async {
    final useCase = GetAccountBalancesUseCase(
      _StubTransactionRepository(const ResultError(ServerFailure(message: 'Falha simulada.'))),
    );

    final result = await useCase([_account('a1', 100)]);

    expect(result.isError, isTrue);
  });
}
