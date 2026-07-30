import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';

class GetDashboardSummaryUseCase extends UseCase<DashboardSummary, NoParams> {
  const GetDashboardSummaryUseCase(this._repository);

  final DashboardRepository _repository;

  @override
  Future<Result<DashboardSummary>> call(NoParams params) => _repository.getSummary();
}