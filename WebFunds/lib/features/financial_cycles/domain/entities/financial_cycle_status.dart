/// A Financial Cycle's lifecycle, in order: created but not confirmed
/// (`draft`), the current working cycle new transactions default into
/// (`active`), ended with reports available (`closed`), read-only
/// historical reference (`archived`).
enum FinancialCycleStatus { draft, active, closed, archived }
