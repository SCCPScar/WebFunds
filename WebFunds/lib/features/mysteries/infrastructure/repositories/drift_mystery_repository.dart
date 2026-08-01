import 'dart:async';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../services/database/app_database.dart';
import '../../../../services/database/daos/mystery_dao.dart';
import '../../domain/entities/mystery.dart';
import '../../domain/entities/mystery_reason.dart';
import '../../domain/entities/mystery_status.dart';
import '../../domain/repositories/mystery_repository.dart';
import '../mappers/mystery_mapper.dart';

/// Real, Drift-backed implementation of [MysteryRepository], following
/// the same shape every other Repository in WebFunds does.
class DriftMysteryRepository implements MysteryRepository {
  const DriftMysteryRepository(this._dao, this._idGenerator, this._clock);

  final MysteryDao _dao;
  final IdGenerator _idGenerator;
  final Clock _clock;

  @override
  Stream<Result<List<Mystery>>> watchAll() {
    return _dao.watchAll().transform(
      StreamTransformer<List<MysteryRow>, Result<List<Mystery>>>.fromHandlers(
        handleData: (rows, sink) {
          sink.add(Success(rows.map(MysteryMapper.toDomain).toList()));
        },
        handleError: (error, stackTrace, sink) {
          sink.add(
            ResultError(
              mapExceptionToFailure(
                CacheException('Não foi possível observar os mistérios.', cause: error),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Future<Result<List<Mystery>>> getAll() async {
    try {
      final rows = await _dao.getAll();
      return Success(rows.map(MysteryMapper.toDomain).toList());
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível carregar os mistérios.', cause: e)),
      );
    }
  }

  @override
  Future<Result<Mystery>> create({
    required String transactionId,
    required MysteryReason reason,
    String? notes,
  }) async {
    try {
      final now = _clock.now();
      final mystery = Mystery(
        id: _idGenerator.generate(),
        transactionId: transactionId,
        reason: reason,
        status: MysteryStatus.open,
        notes: notes,
        createdAt: now,
        updatedAt: now,
      );
      await _dao.insertRow(MysteryMapper.toRow(mystery));
      return Success(mystery);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível criar o mistério.', cause: e)),
      );
    }
  }

  @override
  Future<Result<Mystery>> updateStatus(String id, MysteryStatus status) async {
    return _update(id, (current, now) {
      return Mystery(
        id: current.id,
        transactionId: current.transactionId,
        reason: current.reason,
        status: status,
        notes: current.notes,
        resolvedAt: status == MysteryStatus.resolved ? now : current.resolvedAt,
        createdAt: current.createdAt,
        updatedAt: now,
      );
    });
  }

  @override
  Future<Result<Mystery>> updateNotes(String id, String? notes) async {
    return _update(id, (current, now) {
      return Mystery(
        id: current.id,
        transactionId: current.transactionId,
        reason: current.reason,
        status: current.status,
        notes: notes,
        resolvedAt: current.resolvedAt,
        createdAt: current.createdAt,
        updatedAt: now,
      );
    });
  }

  Future<Result<Mystery>> _update(
    String id,
    Mystery Function(Mystery current, DateTime now) apply,
  ) async {
    try {
      final row = await _dao.findById(id);
      if (row == null) {
        return const ResultError(ValidationFailure(message: 'Este mistério já não existe.'));
      }
      final updated = apply(MysteryMapper.toDomain(row), _clock.now());
      await _dao.updateRow(MysteryMapper.toRow(updated));
      return Success(updated);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível atualizar o mistério.', cause: e)),
      );
    }
  }
}
