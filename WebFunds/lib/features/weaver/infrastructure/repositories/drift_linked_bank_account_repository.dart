import 'dart:async';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/clock.dart';
import '../../../../services/database/app_database.dart';
import '../../../../services/database/daos/linked_bank_account_dao.dart';
import '../../domain/repositories/bank_repository.dart';
import '../../domain/repositories/linked_bank_account_repository.dart';

/// Real, Drift-backed implementation of [LinkedBankAccountRepository],
/// following the same shape every other Repository in WebFunds does.
class DriftLinkedBankAccountRepository implements LinkedBankAccountRepository {
  const DriftLinkedBankAccountRepository(this._dao, this._clock);

  final LinkedBankAccountDao _dao;
  final Clock _clock;

  @override
  Stream<Result<List<BankAccount>>> watchAll() {
    return _dao.watchAll().transform(
          StreamTransformer<List<LinkedBankAccountRow>, Result<List<BankAccount>>>.fromHandlers(
            handleData: (rows, sink) {
              sink.add(Success(rows.map(_toDomain).toList()));
            },
            handleError: (error, stackTrace, sink) {
              sink.add(
                ResultError(
                  mapExceptionToFailure(
                    CacheException('Não foi possível observar as contas ligadas.', cause: error),
                  ),
                ),
              );
            },
          ),
        );
  }

  @override
  Future<Result<void>> saveAll(List<BankAccount> accounts) async {
    try {
      final now = _clock.now();
      for (final account in accounts) {
        await _dao.upsert(
          LinkedBankAccountRow(
            id: account.id,
            institutionName: account.institutionName,
            iban: account.iban,
            displayName: account.displayName,
            linkedAt: now,
          ),
        );
      }
      return const Success(null);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível guardar a conta bancária.', cause: e)),
      );
    }
  }

  @override
  Future<Result<void>> unlink(String id) async {
    try {
      await _dao.deleteById(id);
      return const Success(null);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível desligar a conta.', cause: e)),
      );
    }
  }

  BankAccount _toDomain(LinkedBankAccountRow row) {
    return BankAccount(
      id: row.id,
      institutionName: row.institutionName,
      iban: row.iban,
      displayName: row.displayName,
    );
  }
}
