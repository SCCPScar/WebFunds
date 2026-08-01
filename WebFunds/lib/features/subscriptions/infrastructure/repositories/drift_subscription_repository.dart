import 'dart:async';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../services/database/app_database.dart';
import '../../../../services/database/daos/subscription_dao.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/subscription_frequency.dart';
import '../../domain/entities/subscription_status.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../mappers/subscription_mapper.dart';

/// Real, Drift-backed implementation of [SubscriptionRepository],
/// following the same shape every other Repository in WebFunds does.
class DriftSubscriptionRepository implements SubscriptionRepository {
  const DriftSubscriptionRepository(this._dao, this._idGenerator, this._clock);

  final SubscriptionDao _dao;
  final IdGenerator _idGenerator;
  final Clock _clock;

  @override
  Stream<Result<List<Subscription>>> watchAll() {
    return _dao.watchAll().transform(
      StreamTransformer<List<SubscriptionRow>, Result<List<Subscription>>>.fromHandlers(
        handleData: (rows, sink) {
          sink.add(Success(rows.map(SubscriptionMapper.toDomain).toList()));
        },
        handleError: (error, stackTrace, sink) {
          sink.add(
            ResultError(
              mapExceptionToFailure(
                CacheException('Não foi possível observar as subscrições.', cause: error),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Future<Result<List<Subscription>>> getAll() async {
    try {
      final rows = await _dao.getAll();
      return Success(rows.map(SubscriptionMapper.toDomain).toList());
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível carregar as subscrições.', cause: e)),
      );
    }
  }

  @override
  Future<Result<Subscription>> create({
    required String merchant,
    required Money expectedAmount,
    required SubscriptionFrequency frequency,
    DateTime? nextExpectedDate,
    String? category,
  }) async {
    try {
      final now = _clock.now();
      final subscription = Subscription(
        id: _idGenerator.generate(),
        merchant: merchant,
        expectedAmount: expectedAmount,
        frequency: frequency,
        status: SubscriptionStatus.active,
        nextExpectedDate: nextExpectedDate,
        category: category,
        createdAt: now,
        updatedAt: now,
      );
      await _dao.insertRow(SubscriptionMapper.toRow(subscription));
      return Success(subscription);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível confirmar a subscrição.', cause: e)),
      );
    }
  }

  @override
  Future<Result<Subscription>> updateStatus(String id, SubscriptionStatus status) async {
    try {
      final row = await _dao.findById(id);
      if (row == null) {
        return const ResultError(ValidationFailure(message: 'Esta subscrição já não existe.'));
      }
      final current = SubscriptionMapper.toDomain(row);
      final updated = Subscription(
        id: current.id,
        merchant: current.merchant,
        expectedAmount: current.expectedAmount,
        frequency: current.frequency,
        status: status,
        nextExpectedDate: current.nextExpectedDate,
        category: current.category,
        notes: current.notes,
        createdAt: current.createdAt,
        updatedAt: _clock.now(),
      );
      await _dao.updateRow(SubscriptionMapper.toRow(updated));
      return Success(updated);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível atualizar a subscrição.', cause: e)),
      );
    }
  }
}
