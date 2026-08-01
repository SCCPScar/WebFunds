import 'dart:async';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../services/database/app_database.dart';
import '../../../../services/database/daos/memory_dao.dart';
import '../../domain/entities/memory.dart';
import '../../domain/entities/memory_mood.dart';
import '../../domain/repositories/memory_repository.dart';
import '../mappers/memory_mapper.dart';

/// Real, Drift-backed implementation of [MemoryRepository], following
/// the same shape every other Repository in WebFunds does.
class DriftMemoryRepository implements MemoryRepository {
  const DriftMemoryRepository(this._dao, this._idGenerator, this._clock);

  final MemoryDao _dao;
  final IdGenerator _idGenerator;
  final Clock _clock;

  @override
  Stream<Result<Memory?>> watchByTransactionId(String transactionId) {
    return _dao.watchByTransactionId(transactionId).transform(
      StreamTransformer<MemoryRow?, Result<Memory?>>.fromHandlers(
        handleData: (row, sink) {
          sink.add(Success(row == null ? null : MemoryMapper.toDomain(row)));
        },
        handleError: (error, stackTrace, sink) {
          sink.add(
            ResultError(
              mapExceptionToFailure(
                CacheException('Não foi possível observar a memória.', cause: error),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Future<Result<Memory>> upsert({
    required String transactionId,
    String? title,
    String? narrative,
    MemoryMood? mood,
    List<String> tags = const [],
  }) async {
    try {
      final now = _clock.now();
      final existing = await _dao.findByTransactionId(transactionId);

      final memory = Memory(
        id: existing?.id ?? _idGenerator.generate(),
        transactionId: transactionId,
        title: title,
        narrative: narrative,
        mood: mood,
        tags: tags,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      );

      if (existing == null) {
        await _dao.insertRow(MemoryMapper.toRow(memory));
      } else {
        await _dao.updateRow(MemoryMapper.toRow(memory));
      }
      return Success(memory);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível guardar a memória.', cause: e)),
      );
    }
  }
}
