/// The kinds of local, data-derived observations `WeaverEngine` can
/// produce — no AI involved, every one of these is a straightforward
/// aggregation over Accounts/Transactions.
enum WeaverInsightType {
  totalNetWorth,
  largestAccount,
  lowestBalance,
  accountCount,
  dormantAccounts,
  typeDistribution,
}

/// A single local observation about the owner's finances —
/// `WeaverEngine.generateInsights`'s output. Pure data: no formatting
/// decision beyond a ready-to-read description, no icon (Domain doesn't
/// know about Flutter) — see `WeaverInsightPresentation` for that.
class WeaverInsight {
  const WeaverInsight({required this.type, required this.title, required this.description});

  final WeaverInsightType type;
  final String title;
  final String description;
}
