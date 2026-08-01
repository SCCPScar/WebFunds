import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/utils/clock.dart';
import 'package:webfunds/core/utils/id_generator.dart';
import 'package:webfunds/features/mysteries/application/usecases/resolve_mystery_usecase.dart';
import 'package:webfunds/features/mysteries/domain/entities/mystery_reason.dart';
import 'package:webfunds/features/mysteries/domain/entities/mystery_status.dart';
import 'package:webfunds/features/mysteries/infrastructure/repositories/drift_mystery_repository.dart';
import 'package:webfunds/features/transactions/application/usecases/update_transaction_merchant_category_usecase.dart';
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
  late DriftTransactionRepository transactionRepository;
  late DriftMysteryRepository mysteryRepository;
  late ResolveMysteryUseCase useCase;

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
    useCase = ResolveMysteryUseCase(
      mysteryRepository,
      UpdateTransactionMerchantCategoryUseCase(transactionRepository),
    );
  });

  tearDown(() => database.close());

  test('resolving updates the Transaction and marks the Mystery resolved', () async {
    final transaction = (await transactionRepository.create(
      financialCycleId: 'cycle-1',
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(20),
      transactionDate: DateTime(2026, 1, 5),
    )).dataOrNull!;
    final mystery = (await mysteryRepository.create(
      transactionId: transaction.id,
      reason: MysteryReason.unknownMerchant,
    )).dataOrNull!;

    final result = await useCase(
      ResolveMysteryParams(
        mysteryId: mystery.id,
        transactionId: transaction.id,
        merchant: 'Continente',
        category: 'Groceries',
        notes: 'Compra semanal',
      ),
    );

    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull!.status, MysteryStatus.resolved);
    expect(result.dataOrNull!.notes, 'Compra semanal');
    expect(result.dataOrNull!.resolvedAt, isNotNull);

    final updatedTransaction = await transactionRepository.getById(transaction.id);
    expect(updatedTransaction.dataOrNull!.merchant, 'Continente');
    expect(updatedTransaction.dataOrNull!.category, 'Groceries');
  });

  test('fails validation for a non-existent Mystery', () async {
    final transaction = (await transactionRepository.create(
      financialCycleId: 'cycle-1',
      accountId: 'account-1',
      type: TransactionType.expense,
      amount: Money.fromMajorUnits(20),
      transactionDate: DateTime(2026, 1, 5),
    )).dataOrNull!;

    final result = await useCase(
      ResolveMysteryParams(
        mysteryId: 'does-not-exist',
        transactionId: transaction.id,
        merchant: 'Continente',
        category: 'Groceries',
      ),
    );

    expect(result.isError, isTrue);
  });
}
