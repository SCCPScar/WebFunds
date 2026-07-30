import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../entities/account.dart';
import '../entities/account_type.dart';

abstract class AccountRepository {
  Stream<Result<List<Account>>> watchAll();

  Future<Result<Account?>> getById(String id);

  Future<Result<Account>> create({
    required String name,
    required AccountType type,
    required Money openingBalance,
  });

  Future<Result<Account>> update(Account account);

  Future<Result<void>> archive(String id);
}
