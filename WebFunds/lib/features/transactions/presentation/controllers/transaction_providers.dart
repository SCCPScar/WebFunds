import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_providers.dart';
import '../../../../services/database/daos/transaction_dao.dart';
import '../../application/usecases/create_transaction_usecase.dart';
import '../../application/usecases/get_transaction_by_id_usecase.dart';
import '../../application/usecases/update_transaction_merchant_category_usecase.dart';
import '../../application/usecases/watch_transactions_by_cycle_usecase.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../infrastructure/repositories/drift_transaction_repository.dart';

final transactionDaoProvider = Provider<TransactionDao>((ref) {
  return ref.watch(appDatabaseProvider).transactionDao;
});

/// Real implementation directly — same reasoning as `accountRepositoryProvider`.
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return DriftTransactionRepository(
    ref.watch(transactionDaoProvider),
    ref.watch(idGeneratorProvider),
    ref.watch(clockProvider),
  );
});

final watchTransactionsByCycleUseCaseProvider = Provider<WatchTransactionsByCycleUseCase>((ref) {
  return WatchTransactionsByCycleUseCase(ref.watch(transactionRepositoryProvider));
});

final createTransactionUseCaseProvider = Provider<CreateTransactionUseCase>((ref) {
  return CreateTransactionUseCase(ref.watch(transactionRepositoryProvider));
});

final updateTransactionMerchantCategoryUseCaseProvider =
    Provider<UpdateTransactionMerchantCategoryUseCase>((ref) {
  return UpdateTransactionMerchantCategoryUseCase(ref.watch(transactionRepositoryProvider));
});

final getTransactionByIdUseCaseProvider = Provider<GetTransactionByIdUseCase>((ref) {
  return GetTransactionByIdUseCase(ref.watch(transactionRepositoryProvider));
});

final transactionByIdProvider = FutureProvider.autoDispose.family((ref, String id) {
  return ref.watch(getTransactionByIdUseCaseProvider).call(id);
});

/// What `FinancesPage` watches directly — parameterized by cycle id since
/// Transactions are always viewed grouped by one Financial Cycle
/// (`docs/01-Experience/03-Finances.md`).
final transactionsByCycleStreamProvider =
    StreamProvider.autoDispose.family((ref, String financialCycleId) {
  return ref.watch(watchTransactionsByCycleUseCaseProvider).call(financialCycleId);
});
