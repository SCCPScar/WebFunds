import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../entities/account.dart';
import '../entities/account_type.dart';

/// Contract for Accounts persistence — the reference Repository pattern
/// for WebFunds. Mock/Local (Drift)/Remote/Cached are all equally valid
/// implementations. The UI and Application layer only ever depend on
/// this interface.
///
/// Every method here was validated against "does this make sense for any
/// implementation, not just Drift?" — `watchAll()` is a `Stream` because
/// an always-current total balance is a real product need (Central), not
/// because "Drift can watch".
abstract class AccountRepository {
  /// Active (non-archived) Accounts, updating automatically as they
  /// change.
  Stream<Result<List<Account>>> watchAll();

  Future<Result<Account?>> getById(String id);

  /// `id` and `createdAt` are not parameters — assigning them is this
  /// layer's responsibility, never the caller's.
  Future<Result<Account>> create({
    required String name,
    required AccountType type,
    required Money openingBalance,
  });

  Future<Result<Account>> update(Account account);

  /// No physical deletion — an archived Account keeps its history and
  /// its referential integrity with future Transactions intact.
  Future<Result<void>> archive(String id);
}