import '../../../../services/database/app_database.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/dream.dart';
import '../../domain/entities/dream_movement.dart';
import '../../domain/entities/dream_movement_type.dart';
import '../../domain/entities/dream_status.dart';

/// The single place in WebFunds that knows both the Drift schema and the
/// Dream/DreamMovement Domain entities.
class DreamMapper {
  const DreamMapper._();

  static Dream toDomain(DreamRow row) {
    return Dream(
      id: row.id,
      name: row.name,
      description: row.description,
      targetAmount: Money.fromMinorUnits(
        row.targetAmountMinorUnits,
        currency: row.targetAmountCurrency,
      ),
      reservedAmount: Money.fromMinorUnits(
        row.reservedAmountMinorUnits,
        currency: row.reservedAmountCurrency,
      ),
      status: DreamStatus.values.byName(row.status),
      category: row.category,
      targetDate: row.targetDate,
      completedAt: row.completedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static DreamRow toRow(Dream dream) {
    return DreamRow(
      id: dream.id,
      name: dream.name,
      description: dream.description,
      targetAmountMinorUnits: dream.targetAmount.minorUnits,
      targetAmountCurrency: dream.targetAmount.currency,
      reservedAmountMinorUnits: dream.reservedAmount.minorUnits,
      reservedAmountCurrency: dream.reservedAmount.currency,
      status: dream.status.name,
      category: dream.category,
      targetDate: dream.targetDate,
      completedAt: dream.completedAt,
      createdAt: dream.createdAt,
      updatedAt: dream.updatedAt,
    );
  }

  static DreamMovement movementToDomain(DreamMovementRow row) {
    return DreamMovement(
      id: row.id,
      dreamId: row.dreamId,
      type: DreamMovementType.values.byName(row.type),
      amount: Money.fromMinorUnits(row.amountMinorUnits, currency: row.amountCurrency),
      date: row.date,
      notes: row.notes,
      createdAt: row.createdAt,
    );
  }

  static DreamMovementRow movementToRow(DreamMovement movement) {
    return DreamMovementRow(
      id: movement.id,
      dreamId: movement.dreamId,
      type: movement.type.name,
      amountMinorUnits: movement.amount.minorUnits,
      amountCurrency: movement.amount.currency,
      date: movement.date,
      notes: movement.notes,
      createdAt: movement.createdAt,
    );
  }
}
