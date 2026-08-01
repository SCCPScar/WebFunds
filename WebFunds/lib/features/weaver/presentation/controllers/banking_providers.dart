import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_providers.dart';
import '../../../../services/database/daos/linked_bank_account_dao.dart';
import '../../../../services/supabase/supabase_service.dart';
import '../../application/usecases/complete_bank_link_usecase.dart';
import '../../application/usecases/get_bank_balance_usecase.dart';
import '../../application/usecases/get_bank_transactions_usecase.dart';
import '../../application/usecases/list_institutions_usecase.dart';
import '../../application/usecases/start_bank_authorization_usecase.dart';
import '../../application/usecases/unlink_bank_account_usecase.dart';
import '../../domain/repositories/bank_repository.dart';
import '../../domain/repositories/linked_bank_account_repository.dart';
import '../../infrastructure/repositories/drift_linked_bank_account_repository.dart';
import '../../infrastructure/repositories/supabase_bank_repository.dart';

/// DI wiring for Milestone 6 (Banking) — kept in its own file, separate
/// from `weaver_providers.dart` (Weaver AI v1's category-suggestion
/// providers) and `weaver_analysis_providers.dart` (WeaverEngine), which
/// both stay untouched.
final bankRepositoryProvider = Provider<BankRepository>((ref) {
  return SupabaseBankRepository(ref.watch(supabaseServiceProvider));
});

final linkedBankAccountDaoProvider = Provider<LinkedBankAccountDao>((ref) {
  return ref.watch(appDatabaseProvider).linkedBankAccountDao;
});

final linkedBankAccountRepositoryProvider = Provider<LinkedBankAccountRepository>((ref) {
  return DriftLinkedBankAccountRepository(
    ref.watch(linkedBankAccountDaoProvider),
    ref.watch(clockProvider),
  );
});

final listInstitutionsUseCaseProvider = Provider<ListInstitutionsUseCase>((ref) {
  return ListInstitutionsUseCase(ref.watch(bankRepositoryProvider));
});

final startBankAuthorizationUseCaseProvider = Provider<StartBankAuthorizationUseCase>((ref) {
  return StartBankAuthorizationUseCase(ref.watch(bankRepositoryProvider));
});

final completeBankLinkUseCaseProvider = Provider<CompleteBankLinkUseCase>((ref) {
  return CompleteBankLinkUseCase(
    ref.watch(bankRepositoryProvider),
    ref.watch(linkedBankAccountRepositoryProvider),
  );
});

final unlinkBankAccountUseCaseProvider = Provider<UnlinkBankAccountUseCase>((ref) {
  return UnlinkBankAccountUseCase(ref.watch(linkedBankAccountRepositoryProvider));
});

final getBankBalanceUseCaseProvider = Provider<GetBankBalanceUseCase>((ref) {
  return GetBankBalanceUseCase(ref.watch(bankRepositoryProvider));
});

final getBankTransactionsUseCaseProvider = Provider<GetBankTransactionsUseCase>((ref) {
  return GetBankTransactionsUseCase(ref.watch(bankRepositoryProvider));
});

/// The Accounts already linked, updating automatically.
final linkedBankAccountsStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(linkedBankAccountRepositoryProvider).watchAll();
});

/// Institutions available for Portugal — the only market this app has
/// any reason to support today. `country` is hardcoded rather than a
/// `.family` parameter because there's no UI yet to pick a different
/// one, and no real second market to test against.
final institutionsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(listInstitutionsUseCaseProvider).call('PT');
});

final bankBalanceProvider = FutureProvider.autoDispose.family((ref, String bankAccountId) {
  return ref.watch(getBankBalanceUseCaseProvider).call(bankAccountId);
});

final bankTransactionsProvider = FutureProvider.autoDispose.family((ref, String bankAccountId) {
  return ref.watch(getBankTransactionsUseCaseProvider).call(bankAccountId);
});
