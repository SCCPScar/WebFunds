import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/utils/clock.dart';
import 'package:webfunds/core/utils/id_generator.dart';
import 'package:webfunds/features/accounts/application/usecases/get_account_balances_usecase.dart';
import 'package:webfunds/features/accounts/domain/entities/account_type.dart';
import 'package:webfunds/features/accounts/infrastructure/repositories/drift_account_repository.dart';
import 'package:webfunds/features/central/infrastructure/repositories/local_dashboard_repository.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction_type.dart';
import 'package:webfunds/features/transactions/infrastructure/repositories/drift_transaction_repository.dart';
import 'package:webfunds/services/database/app_database.dart';
import 'package:webfunds/shared/models/money.dart';

class _SequentialIdGenerator implements IdGenerator {
  int _counter = 0;
  @override
  String generate() => 'id-${_counter++}';
}

class _FixedClock implements Clock {
  const _FixedClock(this._fixed);
  final DateTime _fixed;
  @override
  DateTime now() => _fixed;
}

void main() {
  late AppDatabase database;
  late DriftAccountRepository accountRepository;
  late DriftTransactionRepository transactionRepository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    accountRepository = DriftAccountRepository(
      database.accountDao,
      _SequentialIdGenerator(),
      _FixedClock(DateTime(2026, 1, 20)),
    );
    transactionRepository = DriftTransactionRepository(
      database.transactionDao,
      _SequentialIdGenerator(),
      _FixedClock(DateTime(2026, 1, 20)),
    );
  });

  tearDown(() => database.close());

  test('totalBalance sums every Account current balance, recentActivityCount counts the last 7 '
      'days', () async {
    final account1 = (await accountRepository.create(
      name: 'Conta 1',
      type: AccountType.checking,
      openingBalance: Money.fromMajorUnits(100),
    )).dataOrNull!;
    final account2 = (await accountRepository.create(
      name: 'Conta 2',
      type: AccountType.savings,
      openingBalance: Money.fromMajorUnits(50),
    )).dataOrNull!;

    // Within the 7-day window and affects the total balance.
    await transactionRepository.create(
      financialCycleId: 'cycle-1',
      accountId: account1.id,
      type: TransactionType.income,
      amount: Money.fromMajorUnits(30),
      transactionDate: DateTime(2026, 1, 18),
    );
    // Within the window, affects the other Account.
    await transactionRepository.create(
      financialCycleId: 'cycle-1',
      accountId: account2.id,
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(10),
      transactionDate: DateTime(2026, 1, 19),
    );
    // Older than 7 days — still affects the balance, but not the count.
    await transactionRepository.create(
      financialCycleId: 'cycle-1',
      accountId: account1.id,
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(5),
      transactionDate: DateTime(2025, 12, 1),
    );

    final repository = LocalDashboardRepository(
      accountRepository,
      transactionRepository,
      GetAccountBalancesUseCase(transactionRepository),
      _FixedClock(DateTime(2026, 1, 20)),
    );

    final result = await repository.getSummary();

    expect(result.isSuccess, isTrue);
    final summary = result.dataOrNull!;
    // 100 + 30 - 5 (account1) + 50 - 10 (account2) = 165
    expect(summary.totalBalance, Money.fromMajorUnits(165));
    expect(summary.recentActivityCount, 2);
  });

  test('an Account with no Transactions still contributes its opening balance', () async {
    await accountRepository.create(
      name: 'Conta vazia',
      type: AccountType.cash,
      openingBalance: Money.fromMajorUnits(20),
    );

    final repository = LocalDashboardRepository(
      accountRepository,
      transactionRepository,
      GetAccountBalancesUseCase(transactionRepository),
      _FixedClock(DateTime(2026, 1, 20)),
    );

    final result = await repository.getSummary();

    expect(result.dataOrNull!.totalBalance, Money.fromMajorUnits(20));
    expect(result.dataOrNull!.recentActivityCount, 0);
  });
}
