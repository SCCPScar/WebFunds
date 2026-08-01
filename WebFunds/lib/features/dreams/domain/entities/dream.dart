import '../../../../shared/models/money.dart';
import 'dream_status.dart';

/// A financial objective the owner is saving toward —
/// `docs/02-Domain/04-Dreams.md`. Deliberately excludes predictions/
/// insights/Weaver estimates for v1: those need Weaver AI wired to a
/// Dream's contribution history, a later slice.
class Dream {
  const Dream({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.reservedAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.targetDate,
    this.category,
    this.completedAt,
  });

  final String id;
  final String name;
  final Money targetAmount;

  /// Never stored as a running total elsewhere — the single source of
  /// truth for "how much has been reserved so far".
  final Money reservedAmount;

  final DreamStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? description;
  final DateTime? targetDate;
  final String? category;
  final DateTime? completedAt;

  /// 0.0-1.0, clamped — a Dream can be over-funded by design (the owner
  /// may keep contributing past the target).
  double get progress {
    if (targetAmount.minorUnits <= 0) return 0;
    final ratio = reservedAmount.minorUnits / targetAmount.minorUnits;
    return ratio.clamp(0.0, 1.0);
  }
}
