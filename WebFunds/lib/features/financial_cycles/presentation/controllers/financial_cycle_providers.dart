import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_providers.dart';
import '../../../../services/database/daos/financial_cycle_dao.dart';
import '../../application/usecases/close_financial_cycle_usecase.dart';
import '../../application/usecases/start_financial_cycle_usecase.dart';
import '../../application/usecases/watch_active_financial_cycle_usecase.dart';
import '../../domain/repositories/financial_cycle_repository.dart';
import '../../infrastructure/repositories/drift_financial_cycle_repository.dart';

final financialCycleDaoProvider = Provider<FinancialCycleDao>((ref) {
  return ref.watch(appDatabaseProvider).financialCycleDao;
});

/// Real implementation directly — same reasoning as `accountRepositoryProvider`.
final financialCycleRepositoryProvider = Provider<FinancialCycleRepository>((ref) {
  return DriftFinancialCycleRepository(
    ref.watch(financialCycleDaoProvider),
    ref.watch(idGeneratorProvider),
    ref.watch(clockProvider),
  );
});

final watchActiveFinancialCycleUseCaseProvider = Provider<WatchActiveFinancialCycleUseCase>((ref) {
  return WatchActiveFinancialCycleUseCase(ref.watch(financialCycleRepositoryProvider));
});

final startFinancialCycleUseCaseProvider = Provider<StartFinancialCycleUseCase>((ref) {
  return StartFinancialCycleUseCase(ref.watch(financialCycleRepositoryProvider));
});

final closeFinancialCycleUseCaseProvider = Provider<CloseFinancialCycleUseCase>((ref) {
  return CloseFinancialCycleUseCase(ref.watch(financialCycleRepositoryProvider));
});

/// What `CurrentCycleSection` (and later, Finances' cycle selector) watches
/// directly.
final activeFinancialCycleStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(watchActiveFinancialCycleUseCaseProvider).call();
});
