import 'memory_mood.dart';

/// Human context attached to exactly one Transaction —
/// `docs/02-Domain/03-Memories.md`: "A Memory never changes financial
/// values. A Memory only adds context." Deliberately excludes Photos,
/// Receipt, Location and the "future" fields (Weather, Companions, Voice
/// Note) — none of those exist elsewhere in the app yet either.
class Memory {
  const Memory({
    required this.id,
    required this.transactionId,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.narrative,
    this.mood,
  });

  final String id;
  final String transactionId;
  final String? title;

  /// Markdown-supported per the doc; v1 stores and displays it as plain
  /// text — rendering Markdown is presentation-only and can be added
  /// later without touching this entity or its persistence.
  final String? narrative;

  final MemoryMood? mood;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
}
