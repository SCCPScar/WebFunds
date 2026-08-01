import '../../../../shared/models/money.dart';
import 'dream_movement_type.dart';

/// One contribution or withdrawal against a [Dream]'s reserved amount.
class DreamMovement {
  const DreamMovement({
    required this.id,
    required this.dreamId,
    required this.type,
    required this.amount,
    required this.date,
    required this.createdAt,
    this.notes,
  });

  final String id;
  final String dreamId;
  final DreamMovementType type;

  /// Always positive — direction comes from [type].
  final Money amount;
  final DateTime date;
  final DateTime createdAt;
  final String? notes;
}
