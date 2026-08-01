import '../../../../shared/models/money.dart';

/// One slice of a `docs/02-Domain/10-Reports.md` Category Report.
class CategoryBreakdownEntry {
  const CategoryBreakdownEntry({
    required this.category,
    required this.total,
    required this.percentage,
  });

  final String category;
  final Money total;

  /// 0.0-1.0, of total expenses for the cycle.
  final double percentage;
}
