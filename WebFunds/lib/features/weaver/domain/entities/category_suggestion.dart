import 'confidence_level.dart';

/// One Weaver suggestion for a Transaction's category —
/// `docs/02-Domain/06-Weaver.md`: "Every suggestion includes Confidence,
/// Reasoning, Evidence." Never applied automatically; the owner decides.
class CategorySuggestion {
  const CategorySuggestion({
    required this.category,
    required this.confidenceScore,
    required this.confidenceLevel,
    required this.reasoning,
  });

  final String category;
  final int confidenceScore;
  final ConfidenceLevel confidenceLevel;
  final String reasoning;
}
