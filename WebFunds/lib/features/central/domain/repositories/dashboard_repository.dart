import '../../../../core/result/result.dart';
import '../entities/dashboard_summary.dart';

/// Contract for retrieving the Central screen's summary data.
///
/// Standing rule for every Repository in WebFunds: `Mock*` (development),
/// `Local*` (Drift), `Remote*` (Supabase), and `Cached*` (Local-first,
/// Remote-refresh) are all equally valid implementations of the same
/// contract. The Presentation layer only ever depends on
/// [DashboardRepository] — never on a concrete implementation. Swapping
/// implementations happens in exactly one place: the DI provider
/// (`dashboardRepositoryProvider`). No UI file changes when the mock is
/// replaced with a real one.
abstract class DashboardRepository {
  Future<Result<DashboardSummary>> getSummary();
}