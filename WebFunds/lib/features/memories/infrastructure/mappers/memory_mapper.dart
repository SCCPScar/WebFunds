import '../../../../services/database/app_database.dart';
import '../../domain/entities/memory.dart';
import '../../domain/entities/memory_mood.dart';

/// The single place in WebFunds that knows both the Drift schema and the
/// `Memory` Domain entity.
class MemoryMapper {
  const MemoryMapper._();

  static Memory toDomain(MemoryRow row) {
    return Memory(
      id: row.id,
      transactionId: row.transactionId,
      title: row.title,
      narrative: row.narrative,
      mood: row.mood == null ? null : MemoryMood.values.byName(row.mood!),
      tags: row.tags.isEmpty ? const [] : row.tags.split(',').where((t) => t.isNotEmpty).toList(),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static MemoryRow toRow(Memory memory) {
    return MemoryRow(
      id: memory.id,
      transactionId: memory.transactionId,
      title: memory.title,
      narrative: memory.narrative,
      mood: memory.mood?.name,
      tags: memory.tags.join(','),
      createdAt: memory.createdAt,
      updatedAt: memory.updatedAt,
    );
  }
}
