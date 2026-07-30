import '../../../../shared/models/money.dart';

/// Display data for the Central screen's `SummarySection` **only** — not
/// a general-purpose Dashboard DTO. As Accounts, Cards, Goals,
/// Investments, and other blocks gain real content, each gets its own
/// independent model. None are folded into this class, and this class
/// never grows fields for sections it doesn't own.
class DashboardSummary {
  const DashboardSummary({
    required this.totalBalance,
    required this.recentActivityCount,
  });

  final Money totalBalance;
  final int recentActivityCount;
}