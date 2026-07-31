/// The core Transaction types for manual entry — the full taxonomy in
/// `docs/02-Domain/02-Transactions.md` also lists Refund, Correction, Fee,
/// Interest, Cash Withdrawal, Deposit and more, deferred until a real need
/// (bank sync, OCR) requires distinguishing them. Determines the sign of
/// the Transaction's effect: Income positive, Expense negative, Transfer
/// neutral overall.
enum TransactionType { income, expense, transfer }
