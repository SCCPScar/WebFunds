import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_providers.dart';
import '../../../../core/usecase/use_case.dart';
import '../../../accounts/presentation/controllers/account_providers.dart';
import '../../../transactions/presentation/controllers/transaction_providers.dart';
import '../../application/usecases/get_dashboard_summary_usecase.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../infrastructure/repositories/local_dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return LocalDashboardRepository(
    ref.watch(accountRepositoryProvider),
    ref.watch(transactionRepositoryProvider),
    ref.watch(getAccountBalancesUseCaseProvider),
    ref.watch(clockProvider),
  );
});

final getDashboardSummaryUseCaseProvider = Provider<GetDashboardSummaryUseCase>((ref) {
  return GetDashboardSummaryUseCase(ref.watch(dashboardRepositoryProvider));
});

final dashboardSummaryProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(getDashboardSummaryUseCaseProvider).call(const NoParams());
});