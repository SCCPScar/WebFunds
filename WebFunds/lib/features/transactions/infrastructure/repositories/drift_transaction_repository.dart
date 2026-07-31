import 'dart:async';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../services/database/app_database.dart';
import '../../../../services/database/daos/transaction_dao.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../mappers/transaction_mapper.dart';

/// Real, Drift-backed implementation of [TransactionRepository], following
/// the same shape `DriftAccountRepository` established.
class DriftTransactionRepository implements TransactionRepository {
  const DriftTransactionRepository(this._dao, this._idGenerator, this._clock);

  final TransactionDao _dao;
  final IdGenerator _idGenerator;
  final Clock _clock;

  @override
  Stream<Result<List<Transaction>>> watchByCycle(String financialCycleId) {
    return _dao.watchByCycle(financialCycleId).transform(
      StreamTransformer<List<TransactionRow>, Result<List<Transaction>>>.fromHandlers(
        handleData: (rows, sink) {
          sink.add(Success(rows.map(TransactionMapper.toDomain).toList()));
        },
        handleError: (error, stackTrace, sink) {
          sink.add(
            ResultError(
              mapExceptionToFailure(
                CacheException('Não foi possível observar as transações.', cause: error),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Future<Result<Transaction>> create({
    required String financialCycleId,
    required String accountId,
    required TransactionType type,
    required Money amount,
    required DateTime transactionDate,
    String? merchant,
    String? category,
  }) async {
    try {
      final now = _clock.now();
      final transaction = Transaction(
        id: _idGenerator.generate(),
        financialCycleId: financialCycleId,
        accountId: accountId,
        type: type,
        amount: amount,
        transactionDate: transactionDate,
        merchant: merchant,
        category: category,
        createdAt: now,
        updatedAt: now,
      );
      await _dao.insertRow(TransactionMapper.toRow(transaction));
      return Success(transaction);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível criar a transação.', cause: e)),
      );
    }
  }

  @override
  Future<Result<Transaction>> updateMerchantAndCategory(
    String id, {
    String? merchant,
    String? category,
  }) async {
    try {
      final row = await _dao.findById(id);
      if (row == null) {
        return const ResultError(ValidationFailure(message: 'Esta transação já não existe.'));
      }

      final existing = TransactionMapper.toDomain(row);
      final updated = Transaction(
        id: existing.id,
        financialCycleId: existing.financialCycleId,
        accountId: existing.accountId,
        type: existing.type,
        amount: existing.amount,
        transactionDate: existing.transactionDate,
        merchant: merchant,
        category: category,
        createdAt: existing.createdAt,
        updatedAt: _clock.now(),
      );
      await _dao.updateRow(TransactionMapper.toRow(updated));
      return Success(updated);
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(CacheException('Não foi possível atualizar a transação.', cause: e)),
      );
    }
  }
}
