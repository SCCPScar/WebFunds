import 'dart:async';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../services/database/app_database.dart';
import '../../../../services/database/daos/financial_cycle_dao.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/financial_cycle.dart';
import '../../domain/entities/financial_cycle_status.dart';
import '../../domain/repositories/financial_cycle_repository.dart';
import '../mappers/financial_cycle_mapper.dart';

/// Real, Drift-backed implementation of [FinancialCycleRepository],
/// following the same Table → DAO → Mapper → Repository → Providers
/// shape `DriftAccountRepository` established.
class DriftFinancialCycleRepository implements FinancialCycleRepository {
  const DriftFinancialCycleRepository(this._dao, this._idGenerator, this._clock);

  final FinancialCycleDao _dao;
  final IdGenerator _idGenerator;
  final Clock _clock;

  @override
  Stream<Result<FinancialCycle?>> watchActive() {
    return _dao.watchActive().transform(
      StreamTransformer<FinancialCycleRow?, Result<FinancialCycle?>>.fromHandlers(
        handleData: (row, sink) {
          sink.add(Success(row == null ? null : FinancialCycleMapper.toDomain(row)));
        },
        handleError: (error, stackTrace, sink) {
          sink.add(
            ResultError(
              mapExceptionToFailure(
                CacheException('Não foi possível observar o ciclo financeiro.', cause: error),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Future<Result<FinancialCycle?>> getActive() async {
    try {
      final row = await _dao.findActive();
      return Success(row == null ? null : FinancialCycleMapper.toDomain(row));
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível obter o ciclo ativo.', cause: e)),
      );
    }
  }

  @override
  Future<Result<FinancialCycle>> start({
    String? name,
    required DateTime startDate,
    required Money openingBalance,
  }) async {
    try {
      final now = _clock.now();
      final cycle = FinancialCycle(
        id: _idGenerator.generate(),
        name: name,
        startDate: startDate,
        status: FinancialCycleStatus.active,
        openingBalance: openingBalance,
        createdAt: now,
        updatedAt: now,
      );
      await _dao.insertRow(FinancialCycleMapper.toRow(cycle));
      return Success(cycle);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível iniciar o ciclo.', cause: e)),
      );
    }
  }

  @override
  Future<Result<List<FinancialCycle>>> getAllClosed() async {
    try {
      final rows = await _dao.getAllClosed();
      return Success(rows.map(FinancialCycleMapper.toDomain).toList());
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível carregar os ciclos anteriores.', cause: e)),
      );
    }
  }

  @override
  Future<Result<FinancialCycle>> close(String id, {required Money closingBalance}) async {
    try {
      final row = await _dao.findActive();
      if (row == null || row.id != id) {
        return const ResultError(
          ValidationFailure(message: 'Este ciclo já não está ativo.'),
        );
      }

      final closed = FinancialCycleMapper.toDomain(row);
      final updated = FinancialCycle(
        id: closed.id,
        name: closed.name,
        startDate: closed.startDate,
        endDate: _clock.now(),
        status: FinancialCycleStatus.closed,
        openingBalance: closed.openingBalance,
        closingBalance: closingBalance,
        createdAt: closed.createdAt,
        updatedAt: _clock.now(),
      );
      await _dao.updateRow(FinancialCycleMapper.toRow(updated));
      return Success(updated);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível fechar o ciclo.', cause: e)),
      );
    }
  }
}
