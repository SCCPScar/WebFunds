/// `docs/01-Experience/09-Search.md` Search Results groups. Only the 4
/// types this app actually has one-shot repository access to — Merchants
/// and Categories are just fields on a Transaction (already covered by
/// matching within it, not separate searchable objects); Receipts, OCR
/// Text, Banks, Notifications, Weaver Conversations and Settings all
/// need features this app doesn't have yet.
enum SearchResultType { transaction, dream, mystery, subscription }
