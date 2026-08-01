/// The kinds of local, rule-based suggestions `WeaverEngine` can make —
/// still no AI: each rule is a plain condition over Accounts/
/// Transactions, not a learned pattern.
enum WeaverRecommendationType { dormantAccounts, noTransactionsYet, singleAccountConcentration }

/// A suggested action, distinct from a [WeaverAlert] — nothing here is
/// urgent, it's a "you might want to..." rather than a "something's
/// wrong".
class WeaverRecommendation {
  const WeaverRecommendation({
    required this.type,
    required this.title,
    required this.description,
  });

  final WeaverRecommendationType type;
  final String title;
  final String description;
}
