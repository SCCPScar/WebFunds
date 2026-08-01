import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_providers.dart';
import '../../../../services/database/daos/mystery_dao.dart';
import '../../../transactions/presentation/controllers/transaction_providers.dart';
import '../../application/usecases/create_manual_mystery_usecase.dart';
import '../../application/usecases/detect_mysteries_usecase.dart';
import '../../application/usecases/resolve_mystery_usecase.dart';
import '../../application/usecases/update_mystery_status_usecase.dart';
import '../../domain/repositories/mystery_repository.dart';
import '../../infrastructure/repositories/drift_mystery_repository.dart';

final mysteryDaoProvider = Provider<MysteryDao>((ref) {
  return ref.watch(appDatabaseProvider).mysteryDao;
});

final mysteryRepositoryProvider = Provider<MysteryRepository>((ref) {
  return DriftMysteryRepository(
    ref.watch(mysteryDaoProvider),
    ref.watch(idGeneratorProvider),
    ref.watch(clockProvider),
  );
});

final detectMysteriesUseCaseProvider = Provider<DetectMysteriesUseCase>((ref) {
  return DetectMysteriesUseCase(
    ref.watch(transactionRepositoryProvider),
    ref.watch(mysteryRepositoryProvider),
  );
});

final createManualMysteryUseCaseProvider = Provider<CreateManualMysteryUseCase>((ref) {
  return CreateManualMysteryUseCase(ref.watch(mysteryRepositoryProvider));
});

final resolveMysteryUseCaseProvider = Provider<ResolveMysteryUseCase>((ref) {
  return ResolveMysteryUseCase(
    ref.watch(mysteryRepositoryProvider),
    ref.watch(updateTransactionMerchantCategoryUseCaseProvider),
  );
});

final updateMysteryStatusUseCaseProvider = Provider<UpdateMysteryStatusUseCase>((ref) {
  return UpdateMysteryStatusUseCase(ref.watch(mysteryRepositoryProvider));
});

final mysteriesStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(mysteryRepositoryProvider).watchAll();
});

/// Runs detection once per page mount and returns the newly-created
/// Mysteries — same one-shot-on-mount shape as
/// `subscriptionSuggestionsProvider`, except this one persists what it
/// finds instead of only suggesting.
final mysteryDetectionProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(detectMysteriesUseCaseProvider).call();
});
