import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/utils/clock.dart';
import 'package:webfunds/core/utils/id_generator.dart';
import 'package:webfunds/features/financial_cycles/infrastructure/repositories/drift_financial_cycle_repository.dart';
import 'package:webfunds/features/reports/application/usecases/get_cycle_report_usecase.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction_type.dart';
import 'package:webfunds/features/transactions/infrastructure/repositories/drift_transaction_repository.dart';
import 'package:webfunds/services/database/app_database.dart';
import 'package:webfunds/shared/models/money.dart';

class _SequentialIdGenerator implements IdGenerator {
  int _counter = 0;
  @override
  String generate() => 'report-test-id-${_counter++}';
}

class _FixedClock implements Clock {
  _FixedClock(this._fixed);
  final DateTime _fixed;
  @override
  DateTime now() => _fixed;
}

void main() {
  late AppDatabase database;
  late DriftFinancialCycleRepository cycleRepository;
  late DriftTransactionRepository transactionRepository;
  late GetCycleReportUseCase useCase;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    cycleRepository = DriftFinancialCycleRepository(
      database.financialCycleDao,
      _SequentialIdGenerator(),
      _FixedClock(DateTime(2026, 2, 1)),
    );
    transactionRepository = DriftTransactionRepository(
      database.transactionDao,
      _SequentialIdGenerator(),
      _FixedClock(DateTime(2026, 2, 1)),
    );
    useCase = GetCycleReportUseCase(transactionRepository, cycleRepository);
  });

  tearDown(() => database.close());

  test('computes totals, largest movements and category/merchant breakdown', () async {
    final started = await cycleRepository.start(
      startDate: DateTime(2026, 2, 1),
      openingBalance: Money.zero(),
    );
    final cycle = started.dataOrNull!;

    await transactionRepository.create(
      financialCycleId: cycle.id,
      accountId: 'account-1',
      type: TransactionType.income,
      amount: Money.fromMajorUnits(1000),
      transactionDate: DateTime(2026, 2, 2),
      merchant: 'Empregador',
    );
    await transactionRepository.create(
      financialCycleId: cycle.id,
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(50),
      transactionDate: DateTime(2026, 2, 3),
      merchant: 'Continente',
      category: 'Groceries',
    );
    await transactionRepository.create(
      financialCycleId: cycle.id,
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(200),
      transactionDate: DateTime(2026, 2, 4),
      merchant: 'Continente',
      category: 'Groceries',
    );
    await transactionRepository.create(
      financialCycleId: cycle.id,
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(30),
      transactionDate: DateTime(2026, 2, 5),
      merchant: 'Netflix',
      category: 'Entertainment',
    );

    final result = await useCase(cycle);

    expect(result.isSuccess, isTrue);
    final report = result.dataOrNull!;
    expect(report.totalIncome, Money.fromMajorUnits(1000));
    expect(report.totalExpenses, Money.fromMajorUnits(280));
    expect(report.net, Money.fromMajorUnits(720));
    expect(report.transactionCount, 4);
    expect(report.largestIncome?.merchant, 'Empregador');
    expect(report.largestExpense?.merchant, 'Continente');
    expect(report.largestExpense?.amount, Money.fromMajorUnits(200));

    expect(report.categoryBreakdown.first.category, 'Groceries');
    expect(report.categoryBreakdown.first.total, Money.fromMajorUnits(250));
    expect(report.categoryBreakdown.first.percentage, closeTo(250 / 280, 0.001));

    final continente = report.merchantBreakdown.firstWhere((e) => e.merchant == 'Continente');
    expect(continente.total, Money.fromMajorUnits(250));
    expect(continente.visits, 2);

    expect(report.previousCycleIncome, isNull);
    expect(report.previousCycleExpenses, isNull);
  });

  test('compares against the previous closed cycle', () async {
    final firstStarted = await cycleRepository.start(
      startDate: DateTime(2026, 1, 1),
      openingBalance: Money.zero(),
    );
    final firstCycle = firstStarted.dataOrNull!;
    await transactionRepository.create(
      financialCycleId: firstCycle.id,
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(100),
      transactionDate: DateTime(2026, 1, 5),
    );
    await cycleRepository.close(firstCycle.id, closingBalance: Money.zero());

    final secondStarted = await cycleRepository.start(
      startDate: DateTime(2026, 2, 1),
      openingBalance: Money.zero(),
    );
    final secondCycle = secondStarted.dataOrNull!;
    await transactionRepository.create(
      financialCycleId: secondCycle.id,
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(150),
      transactionDate: DateTime(2026, 2, 5),
    );

    final result = await useCase(secondCycle);

    expect(result.dataOrNull!.previousCycleExpenses, Money.fromMajorUnits(100));
  });

  test('handles a Cycle with no Transactions', () async {
    final started = await cycleRepository.start(
      startDate: DateTime(2026, 3, 1),
      openingBalance: Money.zero(),
    );
    final cycle = started.dataOrNull!;

    final result = await useCase(cycle);

    expect(result.isSuccess, isTrue);
    final report = result.dataOrNull!;
    expect(report.totalIncome, Money.zero());
    expect(report.totalExpenses, Money.zero());
    expect(report.transactionCount, 0);
    expect(report.largestExpense, isNull);
    expect(report.categoryBreakdown, isEmpty);
  });
}
