import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';

/// Milestone 6 (Banking) — Enable Banking is the connectivity provider
/// (GoCardless Bank Account Data stopped accepting new signups in July
/// 2025). This is the real contract, refined from the placeholder that
/// shipped with the Weaver milestone once the actual API shape was
/// known: there is no bare "list my accounts" call — Enable Banking only
/// ever returns Accounts as the result of exchanging a consent code, so
/// the app persists that list itself (`LinkedBankAccountRepository`).
class BankInstitution {
  const BankInstitution({required this.name, required this.country});

  final String name;
  final String country;
}

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
  /// Institutions ("ASPSPs" in Open Banking terms) available for one
  /// country — what a bank picker shows.
  Future<Result<List<BankInstitution>>> listInstitutions(String country);

  /// Starts the consent flow with one institution. Returns the URL the
  /// owner must be redirected to — their bank's own login/consent
  /// screen, never anything this app controls.
  Future<Result<Uri>> startAuthorization({
    required BankInstitution institution,
    required String redirectUrl,
  });

  /// Exchanges the `code` Enable Banking appends to `redirectUrl` after
  /// consent for the Accounts now linked.
  Future<Result<List<BankAccount>>> exchangeAuthorizationCode(String code);

  Future<Result<BankBalance>> fetchBalance(String bankAccountId);

  Future<Result<List<BankTransaction>>> fetchTransactions(String bankAccountId);
}
