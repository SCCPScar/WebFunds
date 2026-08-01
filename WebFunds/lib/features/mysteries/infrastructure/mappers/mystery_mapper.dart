import '../../../../services/database/app_database.dart';
import '../../domain/entities/mystery.dart';
import '../../domain/entities/mystery_reason.dart';
import '../../domain/entities/mystery_status.dart';

/// The single place in WebFunds that knows both the Drift schema and the
/// `Mystery` Domain entity.
class MysteryMapper {
  const MysteryMapper._();

  static Mystery toDomain(MysteryRow row) {
    return Mystery(
      id: row.id,
      transactionId: row.transactionId,
      reason: MysteryReason.values.byName(row.reason),
      status: MysteryStatus.values.byName(row.status),
      notes: row.notes,
      resolvedAt: row.resolvedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static MysteryRow toRow(Mystery mystery) {
    return MysteryRow(
      id: mystery.id,
      transactionId: mystery.transactionId,
      reason: mystery.reason.name,
      status: mystery.status.name,
      notes: mystery.notes,
      resolvedAt: mystery.resolvedAt,
      createdAt: mystery.createdAt,
      updatedAt: mystery.updatedAt,
    );
  }
}
