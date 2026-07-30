import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/clock.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../services/database/app_database.dart';
import '../../../../services/database/daos/account_dao.dart';
import '../../application/usecases/archive_account_usecase.dart';
import '../../application/usecases/create_account_usecase.dart';
import '../../application/usecases/watch_accounts_usecase.dart';
import '../../domain/repositories/account_repository.dart';
import '../../infrastructure/repositories/drift_account_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final accountDaoProvider = Provider<AccountDao>((ref) {
  return ref.watch(appDatabaseProvider).accountDao;
});

final idGeneratorProvider = Provider<IdGenerator>((ref) => const UuidIdGenerator());

final clockProvider = Provider<Clock>((ref) => const SystemClock());

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return DriftAccountRepository(
    ref.watch(accountDaoProvider),
    ref.watch(idGeneratorProvider),
    ref.watch(clockProvider),
  );
});

final watchAccountsUseCaseProvider = Provider<WatchAccountsUseCase>((ref) {
  return WatchAccountsUseCase(ref.watch(accountRepositoryProvider));
});

final createAccountUseCaseProvider = Provider<CreateAccountUseCase>((ref) {
  return CreateAccountUseCase(ref.watch(accountRepositoryProvider));
});

final archiveAccountUseCaseProvider = Provider<ArchiveAccountUseCase>((ref) {
  return ArchiveAccountUseCase(ref.watch(accountRepositoryProvider));
});

final accountsStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(watchAccountsUseCaseProvider).call();
});
