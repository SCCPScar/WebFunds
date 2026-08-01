import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/result/result.dart';
import 'package:webfunds/core/usecase/use_case.dart';
import 'package:webfunds/features/accounts/application/usecases/get_account_balances_usecase.dart';
import 'package:webfunds/features/accounts/domain/entities/account.dart';
import 'package:webfunds/features/accounts/domain/entities/account_type.dart';
import 'package:webfunds/features/accounts/domain/repositories/account_repository.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction_type.dart';
import 'package:webfunds/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:webfunds/features/weaver/application/engine/weaver_engine.dart';
import 'package:webfunds/features/weaver/application/usecases/generate_insights_usecase.dart';
import 'package:webfunds/features/weaver/application/usecases/generate_recommendations_usecase.dart';
import 'package:webfunds/features/weaver/domain/entities/weaver_insight.dart';
import 'package:webfunds/features/weaver/domain/entities/weaver_recommendation.dart';
import 'package:webfunds/shared/models/money.dart';

class _StubAccountRepository implements AccountRepository {
  _StubAccountRepository(this.accounts);
  final List<Account> accounts;

  @override
  Stream<Result<List<Account>>> watchAll() => Stream.value(Success(accounts));

  @override
  Future<Result<Account?>> getById(String id) => throw UnimplementedError();

  @override
  Future<Result<Account>> create({
    required String name,
    required AccountType type,
    required Money openingBalance,
  }) =>
      throw UnimplementedError();

  @override
  Future<Result<Account>> update(Account account) => throw UnimplementedError();

  @override
  Future<Result<void>> archive(String id) => throw UnimplementedError();
}

class _StubTransactionRepository implements TransactionRepository {
  _StubTransactionRepository(this.transactions);
  final List<Transaction> transactions;

  @override
  Future<Result<List<Transaction>>> getAll() async => Success(transactions);

  @override
  Stream<Result<List<Transaction>>> watchByCycle(String financialCycleId) =>
      throw UnimplementedError();

  @override
  Future<Result<Transaction?>> getById(String id) => throw UnimplementedError();

  @override
  Future<Result<Transaction>> create({
    required String financialCycleId,
    required String accountId,
    required TransactionType type,
    required Money amount,
    required DateTime transactionDate,
    String? merchant,
    String? category,
  }) =>
      throw UnimplementedError();

  @override
  Future<Result<Transaction>> updateMerchantAndCategory(
    String id, {
    String? merchant,
    String? category,
  }) =>
      throw UnimplementedError();
}

void main() {
  Account account(String id, String name, double opening) {
    return Account(
      id: id,
      name: name,
      type: AccountType.checking,
      openingBalance: Money.fromMajorUnits(opening),
      createdAt: DateTime(2026, 1, 1),
    );
  }

  group('GenerateInsightsUseCase', () {
    test('derives insights from the current Accounts and Transactions', () async {
      final accountRepository = _StubAccountRepository([account('a1', 'Conta à ordem', 100)]);
      final transactionRepository = _StubTransactionRepository(const []);
      final useCase = GenerateInsightsUseCase(
        accountRepository,
        transactionRepository,
        GetAccountBalancesUseCase(transactionRepository),
        const WeaverEngine(),
      );

      final result = await useCase(const NoParams());

      expect(result.isSuccess, isTrue);
      final types = result.dataOrNull!.map((i) => i.type);
      expect(types, contains(WeaverInsightType.totalNetWorth));
      expect(types, contains(WeaverInsightType.accountCount));
    });

    test('returns no insights when there are no Accounts', () async {
      final accountRepository = _StubAccountRepository(const []);
      final transactionRepository = _StubTransactionRepository(const []);
      final useCase = GenerateInsightsUseCase(
        accountRepository,
        transactionRepository,
        GetAccountBalancesUseCase(transactionRepository),
        const WeaverEngine(),
      );

      final result = await useCase(const NoParams());

      expect(result.dataOrNull, isEmpty);
    });
  });

  group('GenerateRecommendationsUseCase', () {
    test('recommends registering Transactions when none exist', () async {
      final accountRepository = _StubAccountRepository([account('a1', 'Conta à ordem', 100)]);
      final transactionRepository = _StubTransactionRepository(const []);
      final useCase = GenerateRecommendationsUseCase(
        accountRepository,
        transactionRepository,
        GetAccountBalancesUseCase(transactionRepository),
        const WeaverEngine(),
      );

      final result = await useCase(const NoParams());

      expect(
        result.dataOrNull!.map((r) => r.type),
        contains(WeaverRecommendationType.noTransactionsYet),
      );
    });

    test('returns no recommendations when there are no Accounts', () async {
      final accountRepository = _StubAccountRepository(const []);
      final transactionRepository = _StubTransactionRepository(const []);
      final useCase = GenerateRecommendationsUseCase(
        accountRepository,
        transactionRepository,
        GetAccountBalancesUseCase(transactionRepository),
        const WeaverEngine(),
      );

      final result = await useCase(const NoParams());

      expect(result.dataOrNull, isEmpty);
    });
  });
}
