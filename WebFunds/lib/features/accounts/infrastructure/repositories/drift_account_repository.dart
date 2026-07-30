import 'dart:async';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../services/database/daos/account_dao.dart';
import '../../../../services/database/tables/accounts_table.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/account_type.dart';
import '../../domain/repositories/account_repository.dart';
import '../mappers/account_mapper.dart';

/// Real, Drift-backed implementation of [AccountRepository] — the
/// reference implementation every future local-persistence Repository in
/// WebFunds follows (Table → DAO → Mapper → Repository → Providers).
class DriftAccountRepository implements AccountRepository {
  const DriftAccountRepository(this._dao, this._idGenerator, this._clock);

  final AccountDao _dao;
  final IdGenerator _idGenerator;
  final Clock _clock;

  @override
  Stream<Result<List<Account>>> watchAll() {
    // `StreamTransformer.fromHandlers` — not `.handleError()` — exposes a
    // `sink`, letting an error event become a real `ResultError` *data*
    // event downstream. This guarantees the returned stream never
    // terminates with an error: every event, data or error, becomes a
    // `Result`.
    return _dao.watchActive().transform(
      StreamTransformer<List<AccountRow>, Result<List<Account>>>.fromHandlers(
        handleData: (rows, sink) {
          sink.add(Success(rows.map(AccountMapper.toDomain).toList()));
        },
        handleError: (error, stackTrace, sink) {
          sink.add(
            ResultError(
              mapExceptionToFailure(
                CacheException('Não foi possível observar as contas.', cause: error),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Future<Result<Account?>> getById(String id) async {
    try {
      final row = await _dao.findById(id);
      return Success(row == null ? null : AccountMapper.toDomain(row));
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível obter a conta.', cause: e)),
      );
    }
  }

  @override
  Future<Result<Account>> create({
    required String name,
    required AccountType type,
    required Money openingBalance,
  }) async {
    try {
      final account = Account(
        id: _idGenerator.generate(),
        name: name,
        type: type,
        openingBalance: openingBalance,
        createdAt: _clock.now(),
      );
      await _dao.insertRow(AccountMapper.toRow(account));
      return Success(account);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível criar a conta.', cause: e)),
      );
    }
  }

  @override
  Future<Result<Account>> update(Account account) async {
    try {
      await _dao.updateRow(AccountMapper.toRow(account));
      return Success(account);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível atualizar a conta.', cause: e)),
      );
    }
  }

  @override
  Future<Result<void>> archive(String id) async {
    try {
      await _dao.archiveById(id);
      return const Success(null);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível arquivar a conta.', cause: e)),
      );
    }
  }
}