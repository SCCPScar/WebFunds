import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/errors/failure.dart';
import 'package:webfunds/core/result/result.dart';
import 'package:webfunds/features/dreams/application/usecases/add_dream_contribution_usecase.dart';
import 'package:webfunds/features/dreams/application/usecases/add_dream_withdrawal_usecase.dart';
import 'package:webfunds/features/dreams/application/usecases/create_dream_usecase.dart';
import 'package:webfunds/features/dreams/domain/entities/dream.dart';
import 'package:webfunds/features/dreams/domain/entities/dream_movement.dart';
import 'package:webfunds/features/dreams/domain/entities/dream_status.dart';
import 'package:webfunds/features/dreams/domain/repositories/dream_repository.dart';
import 'package:webfunds/shared/models/money.dart';

class _StubDreamRepository implements DreamRepository {
  CreateDreamParams? lastCreateParams;
  ({String dreamId, Money amount, String? notes})? lastContribution;
  ({String dreamId, Money amount, String? notes})? lastWithdrawal;

  @override
  Stream<Result<List<Dream>>> watchActive() => throw UnimplementedError();

  @override
  Future<Result<List<Dream>>> getActive() => throw UnimplementedError();

  @override
  Future<Result<Dream?>> getById(String id) => throw UnimplementedError();

  @override
  Stream<Result<Dream?>> watchById(String id) => throw UnimplementedError();

  @override
  Stream<Result<List<DreamMovement>>> watchMovements(String dreamId) => throw UnimplementedError();

  @override
  Future<Result<Dream>> create({
    required String name,
    required Money targetAmount,
    String? description,
    DateTime? targetDate,
    String? category,
  }) async {
    lastCreateParams = CreateDreamParams(
      name: name,
      targetAmount: targetAmount,
      description: description,
      targetDate: targetDate,
      category: category,
    );
    return Success(
      Dream(
        id: 'new-dream',
        name: name,
        targetAmount: targetAmount,
        reservedAmount: Money.zero(),
        status: DreamStatus.active,
        description: description,
        targetDate: targetDate,
        category: category,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
    );
  }

  @override
  Future<Result<Dream>> addContribution({
    required String dreamId,
    required Money amount,
    String? notes,
  }) async {
    lastContribution = (dreamId: dreamId, amount: amount, notes: notes);
    return Success(
      Dream(
        id: dreamId,
        name: 'Dream',
        targetAmount: Money.fromMajorUnits(100),
        reservedAmount: amount,
        status: DreamStatus.active,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
    );
  }

  @override
  Future<Result<Dream>> addWithdrawal({
    required String dreamId,
    required Money amount,
    String? notes,
  }) async {
    lastWithdrawal = (dreamId: dreamId, amount: amount, notes: notes);
    return Success(
      Dream(
        id: dreamId,
        name: 'Dream',
        targetAmount: Money.fromMajorUnits(100),
        reservedAmount: Money.zero(),
        status: DreamStatus.active,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
    );
  }

  @override
  Future<Result<Dream>> archive(String id) => throw UnimplementedError();

  @override
  Future<Result<Dream>> cancel(String id) => throw UnimplementedError();
}

void main() {
  group('CreateDreamUseCase', () {
    test('creates a Dream when the target amount is positive', () async {
      final repository = _StubDreamRepository();
      final useCase = CreateDreamUseCase(repository);

      final result = await useCase(
        CreateDreamParams(
          name: '  Laptop  ',
          targetAmount: Money.fromMajorUnits(1000),
          description: '  novo  ',
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(repository.lastCreateParams?.name, 'Laptop');
      expect(repository.lastCreateParams?.description, 'novo');
    });

    test('rejects a blank name', () async {
      final repository = _StubDreamRepository();
      final useCase = CreateDreamUseCase(repository);

      final result = await useCase(
        CreateDreamParams(name: '   ', targetAmount: Money.fromMajorUnits(100)),
      );

      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
      expect(repository.lastCreateParams, isNull);
    });

    test('rejects a zero target amount', () async {
      final repository = _StubDreamRepository();
      final useCase = CreateDreamUseCase(repository);

      final result = await useCase(
        CreateDreamParams(name: 'Curso', targetAmount: Money.zero()),
      );

      expect(result.isError, isTrue);
      expect(repository.lastCreateParams, isNull);
    });
  });

  group('AddDreamContributionUseCase', () {
    test('rejects a zero amount', () async {
      final repository = _StubDreamRepository();
      final useCase = AddDreamContributionUseCase(repository);

      final result = await useCase(
        AddDreamContributionParams(dreamId: 'dream-1', amount: Money.zero()),
      );

      expect(result.isError, isTrue);
      expect(repository.lastContribution, isNull);
    });

    test('forwards a positive amount to the repository', () async {
      final repository = _StubDreamRepository();
      final useCase = AddDreamContributionUseCase(repository);

      await useCase(
        AddDreamContributionParams(dreamId: 'dream-1', amount: Money.fromMajorUnits(50)),
      );

      expect(repository.lastContribution?.dreamId, 'dream-1');
      expect(repository.lastContribution?.amount, Money.fromMajorUnits(50));
    });
  });

  group('AddDreamWithdrawalUseCase', () {
    test('rejects a zero amount', () async {
      final repository = _StubDreamRepository();
      final useCase = AddDreamWithdrawalUseCase(repository);

      final result = await useCase(
        AddDreamWithdrawalParams(dreamId: 'dream-1', amount: Money.zero()),
      );

      expect(result.isError, isTrue);
      expect(repository.lastWithdrawal, isNull);
    });

    test('forwards a positive amount to the repository', () async {
      final repository = _StubDreamRepository();
      final useCase = AddDreamWithdrawalUseCase(repository);

      await useCase(
        AddDreamWithdrawalParams(dreamId: 'dream-1', amount: Money.fromMajorUnits(30)),
      );

      expect(repository.lastWithdrawal?.dreamId, 'dream-1');
      expect(repository.lastWithdrawal?.amount, Money.fromMajorUnits(30));
    });
  });
}
