import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/errors/failure.dart';
import 'package:webfunds/core/result/result.dart';
import 'package:webfunds/features/central/domain/entities/dashboard_summary.dart';
import 'package:webfunds/features/central/domain/repositories/dashboard_repository.dart';
import 'package:webfunds/features/central/infrastructure/repositories/mock_dashboard_repository.dart';
import 'package:webfunds/shared/models/money.dart';

class _FailingDashboardRepository implements DashboardRepository {
  const _FailingDashboardRepository();

  @override
  Future<Result<DashboardSummary>> getSummary() async {
    return const ResultError(ServerFailure(message: 'Falha simulada.'));
  }
}

void main() {
  group('DashboardRepository contract', () {
    test('MockDashboardRepository returns a Success with a DashboardSummary', () async {
      const DashboardRepository repository = MockDashboardRepository();
      final result = await repository.getSummary();

      expect(result, isA<Success<DashboardSummary>>());
      final summary = result.dataOrNull!;
      expect(summary.totalBalance, Money.fromMajorUnits(1284.32));
      expect(summary.recentActivityCount, 3);
    });

    test('any DashboardRepository implementation can report failure', () async {
      const DashboardRepository repository = _FailingDashboardRepository();
      final result = await repository.getSummary();

      expect(result, isA<ResultError<DashboardSummary>>());
      expect(result.failureOrNull, isA<ServerFailure>());
    });
  });
}
