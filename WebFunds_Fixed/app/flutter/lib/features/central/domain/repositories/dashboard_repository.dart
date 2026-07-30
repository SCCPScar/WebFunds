import '../../../../core/result/result.dart';
import '../entities/dashboard_summary.dart';

abstract class DashboardRepository {
  Future<Result<DashboardSummary>> getSummary();
}
