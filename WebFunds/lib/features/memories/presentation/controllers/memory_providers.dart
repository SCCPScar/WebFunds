import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_providers.dart';
import '../../../../services/database/daos/memory_dao.dart';
import '../../application/usecases/upsert_memory_usecase.dart';
import '../../domain/repositories/memory_repository.dart';
import '../../infrastructure/repositories/drift_memory_repository.dart';

final memoryDaoProvider = Provider<MemoryDao>((ref) {
  return ref.watch(appDatabaseProvider).memoryDao;
});

final memoryRepositoryProvider = Provider<MemoryRepository>((ref) {
  return DriftMemoryRepository(
    ref.watch(memoryDaoProvider),
    ref.watch(idGeneratorProvider),
    ref.watch(clockProvider),
  );
});

final upsertMemoryUseCaseProvider = Provider<UpsertMemoryUseCase>((ref) {
  return UpsertMemoryUseCase(ref.watch(memoryRepositoryProvider));
});

final memoryByTransactionStreamProvider =
    StreamProvider.autoDispose.family((ref, String transactionId) {
  return ref.watch(memoryRepositoryProvider).watchByTransactionId(transactionId);
});
