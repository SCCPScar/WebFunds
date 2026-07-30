import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// Temporary implementation — same role `FakeSessionRepository` played
/// for Auth before being replaced. The artificial delay exists only so
/// `CentralPage` actually shows its Loading state during development.
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