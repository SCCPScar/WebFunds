import '../../../../core/result/result.dart';
import '../../domain/entities/memory.dart';
import '../../domain/entities/memory_mood.dart';
import '../../domain/repositories/memory_repository.dart';

class UpsertMemoryParams {
  const UpsertMemoryParams({
    required this.transactionId,
    this.title,
    this.narrative,
    this.mood,
    this.tags = const [],
  });

  final String transactionId;
  final String? title;
  final String? narrative;
  final MemoryMood? mood;
  final List<String> tags;
}

class UpsertMemoryUseCase {
  const UpsertMemoryUseCase(this._repository);

  final MemoryRepository _repository;

  Future<Result<Memory>> call(UpsertMemoryParams params) {
    final title = params.title?.trim();
    final narrative = params.narrative?.trim();
    return _repository.upsert(
      transactionId: params.transactionId,
      title: title == null || title.isEmpty ? null : title,
      narrative: narrative == null || narrative.isEmpty ? null : narrative,
      mood: params.mood,
      tags: params.tags,
    );
  }
}
