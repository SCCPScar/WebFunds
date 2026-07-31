import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_providers.dart';
import '../../../../services/database/daos/account_dao.dart';
import '../../application/usecases/archive_account_usecase.dart';
import '../../application/usecases/create_account_usecase.dart';
import '../../application/usecases/watch_accounts_usecase.dart';
import '../../domain/repositories/account_repository.dart';
import '../../infrastructure/repositories/drift_account_repository.dart';

final accountDaoProvider = Provider<AccountDao>((ref) {
  return ref.watch(appDatabaseProvider).accountDao;
});

/// Real implementation directly — Accounts has no reason to start as a
/// Mock; Drift works fully offline today.
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

/// What a future Accounts UI (and the 01.8 Central integration) will
/// watch directly.
final accountsStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(watchAccountsUseCaseProvider).call();
});