import '../../../../shared/models/money.dart';
import '../../../../core/result/result.dart';

/// Preparation only, for the GoCardless integration that's still blocked
/// on the owner's Secret ID/Key and completing the Open Banking consent
/// flow. No implementation exists, nothing implements this, nothing is
/// wired into a Riverpod provider — no HTTP, no OAuth. When that work
/// starts, only a `DriftBankRepository`/`GoCardlessBankRepository`
/// adapter needs writing; this contract, and everything built against
/// it, stays untouched.
class BankAccount {
  const BankAccount({
    required this.id,
    required this.institutionName,
    required this.iban,
    required this.displayName,
  });

  final String id;
  final String institutionName;
  final String iban;
  final String displayName;
}

class BankTransaction {
  const BankTransaction({
    required this.id,
    required this.bankAccountId,
    required this.amount,
    required this.bookingDate,
    this.remittanceInformation,
  });

  final String id;
  final String bankAccountId;
  final Money amount;
  final DateTime bookingDate;
  final String? remittanceInformation;
}

class BankBalance {
  const BankBalance({required this.bankAccountId, required this.amount, required this.asOf});

  final String bankAccountId;
  final Money amount;
  final DateTime asOf;
}

abstract class BankRepository {
  Future<Result<List<BankAccount>>> fetchAccounts();
  Future<Result<List<BankTransaction>>> fetchTransactions(String bankAccountId);
  Future<Result<BankBalance>> fetchBalance(String bankAccountId);
}
