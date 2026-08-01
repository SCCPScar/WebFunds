import '../../../../core/result/result.dart';
import '../entities/memory.dart';
import '../entities/memory_mood.dart';

/// Contract for Memory persistence. `docs/02-Domain/03-Memories.md`
/// describes a Memory as optional and linked to exactly one Transaction
/// — v1 enforces at most one Memory per Transaction, so "add context" is
/// always a single create-or-update, never a growing list.
abstract class MemoryRepository {
  Stream<Result<Memory?>> watchByTransactionId(String transactionId);

  /// Creates a Memory for this Transaction if none exists yet, otherwise
  /// updates the existing one — `id`/`createdAt`/`updatedAt` are not
  /// parameters, assigning them is this layer's responsibility.
  Future<Result<Memory>> upsert({
    required String transactionId,
    String? title,
    String? narrative,
    MemoryMood? mood,
    List<String> tags = const [],
  });
}
