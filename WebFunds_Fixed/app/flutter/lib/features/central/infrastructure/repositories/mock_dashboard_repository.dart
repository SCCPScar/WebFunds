import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';

class MockDashboardRepository implements DashboardRepository {
  const MockDashboardRepository();

  @override
  Future<Result<DashboardSummary>> getSummary() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return Success(
      DashboardSummary(
        totalBalance: Money.fromMajorUnits(1284.32),
        recentActivityCount: 3,
      ),
    );
  }
}
