/// `docs/02-Domain/04-Dreams.md` Dream Lifecycle. `draft` is not offered
/// by the v1 UI — every Dream is created directly `active`, the same
/// simplification Financial Cycles made — but the value stays in the
/// enum so the schema already matches the full lifecycle.
enum DreamStatus { draft, active, completed, archived, cancelled }
