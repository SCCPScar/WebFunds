import 'mystery_reason.dart';
import 'mystery_status.dart';

/// A Transaction that needs more context before it's fully understood —
/// `docs/02-Domain/05-Mysteries.md`. "It stores uncertainty. Not
/// incorrect information." Linked to exactly one Transaction; resolving
/// it never deletes it, only marks it `resolved`.
class Mystery {
  const Mystery({
    required this.id,
    required this.transactionId,
    required this.reason,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.resolvedAt,
  });

  final String id;
  final String transactionId;
  final MysteryReason reason;
  final MysteryStatus status;
  final String? notes;
  final DateTime? resolvedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
}
