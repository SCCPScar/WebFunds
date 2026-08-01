/// `docs/02-Domain/05-Mysteries.md` Lifecycle, collapsed for v1: without
/// Weaver wired to individual Transactions yet, there is no distinct
/// "Analyzed" (AI evidence) or "Reviewed" (AI suggestions shown) stage to
/// persist — both fold into `open`.
enum MysteryStatus { open, resolved, archived }
