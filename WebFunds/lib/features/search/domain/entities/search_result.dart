import 'search_result_type.dart';

/// One matched entity from `SearchUseCase` — a display-ready projection,
/// not the underlying Transaction/Dream/Mystery/Subscription itself, so
/// the search page never needs to know each entity's own shape.
class SearchResult {
  const SearchResult({
    required this.type,
    required this.entityId,
    required this.title,
    required this.subtitle,
    required this.sortDate,
  });

  final SearchResultType type;

  /// The id of the underlying Transaction/Dream/Mystery/Subscription —
  /// what a tap would deep-link to, once each of those has a standalone
  /// detail route.
  final String entityId;

  final String title;
  final String subtitle;

  /// Used only to sort results newest-first within their group — the
  /// doc's "Relevance" default sort needs a scoring model this app has
  /// no basis for yet (no query analytics, no Weaver ranking), so v1
  /// sorts recency instead.
  final DateTime sortDate;
}
