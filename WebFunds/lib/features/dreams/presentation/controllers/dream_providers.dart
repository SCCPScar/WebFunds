import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_providers.dart';
import '../../../../services/database/daos/dream_dao.dart';
import '../../application/usecases/add_dream_contribution_usecase.dart';
import '../../application/usecases/add_dream_withdrawal_usecase.dart';
import '../../application/usecases/archive_dream_usecase.dart';
import '../../application/usecases/cancel_dream_usecase.dart';
import '../../application/usecases/create_dream_usecase.dart';
import '../../application/usecases/watch_active_dreams_usecase.dart';
import '../../application/usecases/watch_dream_by_id_usecase.dart';
import '../../application/usecases/watch_dream_movements_usecase.dart';
import '../../domain/repositories/dream_repository.dart';
import '../../infrastructure/repositories/drift_dream_repository.dart';

final dreamDaoProvider = Provider<DreamDao>((ref) {
  return ref.watch(appDatabaseProvider).dreamDao;
});

final dreamRepositoryProvider = Provider<DreamRepository>((ref) {
  return DriftDreamRepository(
    ref.watch(dreamDaoProvider),
    ref.watch(idGeneratorProvider),
    ref.watch(clockProvider),
  );
});

final watchActiveDreamsUseCaseProvider = Provider<WatchActiveDreamsUseCase>((ref) {
  return WatchActiveDreamsUseCase(ref.watch(dreamRepositoryProvider));
});

final watchDreamMovementsUseCaseProvider = Provider<WatchDreamMovementsUseCase>((ref) {
  return WatchDreamMovementsUseCase(ref.watch(dreamRepositoryProvider));
});

final watchDreamByIdUseCaseProvider = Provider<WatchDreamByIdUseCase>((ref) {
  return WatchDreamByIdUseCase(ref.watch(dreamRepositoryProvider));
});

final createDreamUseCaseProvider = Provider<CreateDreamUseCase>((ref) {
  return CreateDreamUseCase(ref.watch(dreamRepositoryProvider));
});

final addDreamContributionUseCaseProvider = Provider<AddDreamContributionUseCase>((ref) {
  return AddDreamContributionUseCase(ref.watch(dreamRepositoryProvider));
});

final addDreamWithdrawalUseCaseProvider = Provider<AddDreamWithdrawalUseCase>((ref) {
  return AddDreamWithdrawalUseCase(ref.watch(dreamRepositoryProvider));
});

final archiveDreamUseCaseProvider = Provider<ArchiveDreamUseCase>((ref) {
  return ArchiveDreamUseCase(ref.watch(dreamRepositoryProvider));
});

final cancelDreamUseCaseProvider = Provider<CancelDreamUseCase>((ref) {
  return CancelDreamUseCase(ref.watch(dreamRepositoryProvider));
});

final activeDreamsStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(watchActiveDreamsUseCaseProvider).call();
});

final dreamMovementsStreamProvider = StreamProvider.autoDispose.family((ref, String dreamId) {
  return ref.watch(watchDreamMovementsUseCaseProvider).call(dreamId);
});

final dreamByIdStreamProvider = StreamProvider.autoDispose.family((ref, String dreamId) {
  return ref.watch(watchDreamByIdUseCaseProvider).call(dreamId);
});
