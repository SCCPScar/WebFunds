import '../../../../core/result/result.dart';
import 'bank_repository.dart';

/// Local persistence for the Accounts a consent exchange returned —
/// Enable Banking itself has no "list my accounts" call, so this is the
/// only place the app's own record of "which Accounts are linked" lives.
abstract class LinkedBankAccountRepository {
  Stream<Result<List<BankAccount>>> watchAll();

  Future<Result<void>> saveAll(List<BankAccount> accounts);

  Future<Result<void>> unlink(String id);
}
