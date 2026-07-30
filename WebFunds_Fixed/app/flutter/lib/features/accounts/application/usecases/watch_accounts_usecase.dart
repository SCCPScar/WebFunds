import '../../../../core/result/result.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';

class WatchAccountsUseCase {
  const WatchAccountsUseCase(this._repository);

  final AccountRepository _repository;

  Stream<Result<List<Account>>> call() => _repository.watchAll();
}
