import '../../../../shared/models/money.dart';

/// One row of a `docs/02-Domain/10-Reports.md` Merchant Report.
class MerchantBreakdownEntry {
  const MerchantBreakdownEntry({
    required this.merchant,
    required this.total,
    required this.visits,
  });

  final String merchant;
  final Money total;
  final int visits;
}
