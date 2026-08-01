import 'dart:async';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../services/database/app_database.dart';
import '../../../../services/database/daos/dream_dao.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/dream.dart';
import '../../domain/entities/dream_movement.dart';
import '../../domain/entities/dream_movement_type.dart';
import '../../domain/entities/dream_status.dart';
import '../../domain/repositories/dream_repository.dart';
import '../mappers/dream_mapper.dart';

/// Real, Drift-backed implementation of [DreamRepository], following the
/// same shape `DriftAccountRepository`/`DriftTransactionRepository`
/// established.
class DriftDreamRepository implements DreamRepository {
  const DriftDreamRepository(this._dao, this._idGenerator, this._clock);

  final DreamDao _dao;
  final IdGenerator _idGenerator;
  final Clock _clock;

  @override
  Stream<Result<List<Dream>>> watchActive() {
    return _dao.watchActive().transform(
          StreamTransformer<List<DreamRow>, Result<List<Dream>>>.fromHandlers(
            handleData: (rows, sink) {
              sink.add(Success(rows.map(DreamMapper.toDomain).toList()));
            },
            handleError: (error, stackTrace, sink) {
              sink.add(
                ResultError(
                  mapExceptionToFailure(
                    CacheException('Não foi possível observar os objetivos.', cause: error),
                  ),
                ),
              );
            },
          ),
        );
  }

  @override
  Future<Result<List<Dream>>> getActive() async {
    try {
      final rows = await _dao.getActive();
      return Success(rows.map(DreamMapper.toDomain).toList());
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível carregar os objetivos.', cause: e)),
      );
    }
  }

  @override
  Future<Result<Dream?>> getById(String id) async {
    try {
      final row = await _dao.findById(id);
      return Success(row == null ? null : DreamMapper.toDomain(row));
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível carregar o objetivo.', cause: e)),
      );
    }
  }

  @override
  Stream<Result<Dream?>> watchById(String id) {
    return _dao.watchById(id).transform(
          StreamTransformer<DreamRow?, Result<Dream?>>.fromHandlers(
            handleData: (row, sink) {
              sink.add(Success(row == null ? null : DreamMapper.toDomain(row)));
            },
            handleError: (error, stackTrace, sink) {
              sink.add(
                ResultError(
                  mapExceptionToFailure(
                    CacheException('Não foi possível observar o objetivo.', cause: error),
                  ),
                ),
              );
            },
          ),
        );
  }

  @override
  Stream<Result<List<DreamMovement>>> watchMovements(String dreamId) {
    return _dao.watchMovements(dreamId).transform(
          StreamTransformer<List<DreamMovementRow>, Result<List<DreamMovement>>>.fromHandlers(
            handleData: (rows, sink) {
              sink.add(Success(rows.map(DreamMapper.movementToDomain).toList()));
            },
            handleError: (error, stackTrace, sink) {
              sink.add(
                ResultError(
                  mapExceptionToFailure(
                    CacheException('Não foi possível observar as contribuições.', cause: error),
                  ),
                ),
              );
            },
          ),
        );
  }

  @override
  Future<Result<Dream>> create({
    required String name,
    required Money targetAmount,
    String? description,
    DateTime? targetDate,
    String? category,
  }) async {
    try {
      final now = _clock.now();
      final dream = Dream(
        id: _idGenerator.generate(),
        name: name,
        targetAmount: targetAmount,
        reservedAmount: Money.zero(currency: targetAmount.currency),
        status: DreamStatus.active,
        description: description,
        targetDate: targetDate,
        category: category,
        createdAt: now,
        updatedAt: now,
      );
      await _dao.insertDream(DreamMapper.toRow(dream));
      return Success(dream);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível criar o objetivo.', cause: e)),
      );
    }
  }

  @override
  Future<Result<Dream>> addContribution({
    required String dreamId,
    required Money amount,
    String? notes,
  }) async {
    return _recordMovement(
      dreamId: dreamId,
      type: DreamMovementType.contribution,
      amount: amount,
      notes: notes,
      applyToReserved: (dream) {
        final newReserved = dream.reservedAmount + amount;
        final completesNow = dream.status == DreamStatus.active &&
            newReserved.minorUnits >= dream.targetAmount.minorUnits;
        return (
          reserved: newReserved,
          status: completesNow ? DreamStatus.completed : dream.status,
          completedAt: completesNow ? _clock.now() : dream.completedAt,
        );
      },
    );
  }

  @override
  Future<Result<Dream>> addWithdrawal({
    required String dreamId,
    required Money amount,
    String? notes,
  }) async {
    final existing = await _dao.findById(dreamId);
    if (existing == null) {
      return const ResultError(ValidationFailure(message: 'Este objetivo já não existe.'));
    }
    final current = DreamMapper.toDomain(existing);
    if (amount.minorUnits > current.reservedAmount.minorUnits) {
      return const ResultError(
        ValidationFailure(message: 'Não podes retirar mais do que o valor reservado.'),
      );
    }

    return _recordMovement(
      dreamId: dreamId,
      type: DreamMovementType.withdrawal,
      amount: amount,
      notes: notes,
      applyToReserved: (dream) {
        final newReserved = dream.reservedAmount - amount;
        final reopens = dream.status == DreamStatus.completed &&
            newReserved.minorUnits < dream.targetAmount.minorUnits;
        return (
          reserved: newReserved,
          status: reopens ? DreamStatus.active : dream.status,
          completedAt: reopens ? null : dream.completedAt,
        );
      },
    );
  }

  Future<Result<Dream>> _recordMovement({
    required String dreamId,
    required DreamMovementType type,
    required Money amount,
    required ({Money reserved, DreamStatus status, DateTime? completedAt}) Function(Dream dream)
        applyToReserved,
    String? notes,
  }) async {
    try {
      final row = await _dao.findById(dreamId);
      if (row == null) {
        return const ResultError(ValidationFailure(message: 'Este objetivo já não existe.'));
      }

      final current = DreamMapper.toDomain(row);
      final now = _clock.now();
      final update = applyToReserved(current);

      final updated = Dream(
        id: current.id,
        name: current.name,
        targetAmount: current.targetAmount,
        reservedAmount: update.reserved,
        status: update.status,
        description: current.description,
        targetDate: current.targetDate,
        category: current.category,
        completedAt: update.completedAt,
        createdAt: current.createdAt,
        updatedAt: now,
      );

      final movement = DreamMovement(
        id: _idGenerator.generate(),
        dreamId: dreamId,
        type: type,
        amount: amount,
        date: now,
        notes: notes,
        createdAt: now,
      );

      await _dao.recordMovement(DreamMapper.movementToRow(movement), DreamMapper.toRow(updated));
      return Success(updated);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível registar o movimento.', cause: e)),
      );
    }
  }

  @override
  Future<Result<Dream>> archive(String id) => _transitionStatus(id, DreamStatus.archived);

  @override
  Future<Result<Dream>> cancel(String id) => _transitionStatus(id, DreamStatus.cancelled);

  Future<Result<Dream>> _transitionStatus(String id, DreamStatus status) async {
    try {
      final row = await _dao.findById(id);
      if (row == null) {
        return const ResultError(ValidationFailure(message: 'Este objetivo já não existe.'));
      }
      final current = DreamMapper.toDomain(row);
      final updated = Dream(
        id: current.id,
        name: current.name,
        targetAmount: current.targetAmount,
        reservedAmount: current.reservedAmount,
        status: status,
        description: current.description,
        targetDate: current.targetDate,
        category: current.category,
        completedAt: current.completedAt,
        createdAt: current.createdAt,
        updatedAt: _clock.now(),
      );
      await _dao.updateDream(DreamMapper.toRow(updated));
      return Success(updated);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível atualizar o objetivo.', cause: e)),
      );
    }
  }
}
