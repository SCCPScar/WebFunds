import '../../../../shared/models/money.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.totalBalance,
    required this.recentActivityCount,
  });

  final Money totalBalance;
  final int recentActivityCount;
}
