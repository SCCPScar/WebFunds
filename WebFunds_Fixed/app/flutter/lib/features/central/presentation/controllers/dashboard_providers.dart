import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/use_case.dart';
import '../../application/usecases/get_dashboard_summary_usecase.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../infrastructure/repositories/mock_dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return const MockDashboardRepository();
});

final getDashboardSummaryUseCaseProvider = Provider<GetDashboardSummaryUseCase>((ref) {
  return GetDashboardSummaryUseCase(ref.watch(dashboardRepositoryProvider));
});

final dashboardSummaryProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(getDashboardSummaryUseCaseProvider).call(const NoParams());
});
