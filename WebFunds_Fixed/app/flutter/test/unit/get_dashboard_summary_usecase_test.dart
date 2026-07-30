import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/result/result.dart';
import 'package:webfunds/core/usecase/use_case.dart';
import 'package:webfunds/features/central/application/usecases/get_dashboard_summary_usecase.dart';
import 'package:webfunds/features/central/domain/entities/dashboard_summary.dart';
import 'package:webfunds/features/central/domain/repositories/dashboard_repository.dart';
import 'package:webfunds/shared/models/money.dart';

class _StubDashboardRepository implements DashboardRepository {
  const _StubDashboardRepository(this._result);
  final Result<DashboardSummary> _result;

  @override
  Future<Result<DashboardSummary>> getSummary() async => _result;
}

void main() {
  test('GetDashboardSummaryUseCase passes through the repository result unchanged', () async {
    final summary = DashboardSummary(
      totalBalance: Money.fromMajorUnits(42),
      recentActivityCount: 1,
    );
    final useCase = GetDashboardSummaryUseCase(
      _StubDashboardRepository(Success(summary)),
    );

    final result = await useCase(const NoParams());

    expect(result.dataOrNull, summary);
  });
}
