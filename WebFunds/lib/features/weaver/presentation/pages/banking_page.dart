import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/errors/failure.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../application/usecases/start_bank_authorization_usecase.dart';
import '../../domain/repositories/bank_repository.dart';
import '../controllers/banking_providers.dart';

/// The Application's registered redirect URL at Enable Banking — a
/// static page (`web/banking/callback.html`), not a Flutter route: OAuth
/// redirect URLs can't contain a fragment, and this app uses hash-based
/// routing. That static page hands off to the real `/banking/callback`
/// route (`BankingCallbackPage`) with whatever query parameters Enable
/// Banking appended.
const _kEnableBankingRedirectUrl = 'https://sccpscar.github.io/WebFunds/banking/callback.html';

/// Milestone 6 (Banking) — links a bank via Enable Banking (read-only
/// Account Information only; GoCardless Bank Account Data stopped
/// accepting new signups in July 2025) and lists what's linked so far.
/// Standalone route, reachable from `AccountsPage`'s AppBar.
class BankingPage extends ConsumerWidget {
  const BankingPage({super.key});

  void _openInstitutionPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => const _InstitutionPickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(linkedBankAccountsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Banking')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openInstitutionPicker(context),
        icon: const Icon(AppIcons.add),
        label: const Text('Ligar banco'),
      ),
      body: accountsAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, stackTrace) => AppErrorView(
          failure: const UnknownFailure(),
          onRetry: () => ref.invalidate(linkedBankAccountsStreamProvider),
        ),
        data: (result) => result.fold(
          onSuccess: (accounts) {
            if (accounts.isEmpty) {
              return const AppEmptyState(
                icon: AppIcons.banking,
                message:
                    'Ainda não ligaste nenhuma conta bancária. O acesso é sempre só de leitura — '
                    'esta app nunca pode mover dinheiro.',
              );
            }
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [for (final account in accounts) _BankAccountTile(account: account)],
            );
          },
          onError: (failure) => AppErrorView(
            failure: failure,
            onRetry: () => ref.invalidate(linkedBankAccountsStreamProvider),
          ),
        ),
      ),
    );
  }
}

class _BankAccountTile extends ConsumerWidget {
  const _BankAccountTile({required this.account});

  final BankAccount account;

  Future<void> _unlink(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(unlinkBankAccountUseCaseProvider).call(account.id);
    if (!context.mounted) return;
    result.fold(
      onSuccess: (_) {},
      onError: (failure) =>
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message))),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(bankBalanceProvider(account.id));

    return Card(
      child: ListTile(
        leading: const Icon(AppIcons.banking),
        title: Text(account.displayName),
        subtitle: Text(account.iban.isEmpty ? account.institutionName : account.iban),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            balanceAsync.when(
              loading: () => const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (error, stackTrace) => const Text('—'),
              data: (result) => Text(
                result.fold(onSuccess: (b) => b.amount.format(), onError: (f) => '—'),
              ),
            ),
            IconButton(
              icon: const Icon(AppIcons.unlink),
              tooltip: 'Desligar',
              onPressed: () => _unlink(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstitutionPickerSheet extends ConsumerWidget {
  const _InstitutionPickerSheet();

  Future<void> _link(BuildContext context, WidgetRef ref, BankInstitution institution) async {
    final result = await ref.read(startBankAuthorizationUseCaseProvider).call(
      StartBankAuthorizationParams(
        institution: institution,
        redirectUrl: _kEnableBankingRedirectUrl,
      ),
    );
    if (!context.mounted) return;
    await result.fold(
      onSuccess: (uri) => launchUrl(uri, webOnlyWindowName: '_self'),
      onError: (failure) async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final institutionsAsync = ref.watch(institutionsProvider);

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text('Escolhe o teu banco', style: Theme.of(context).textTheme.headlineMedium),
            ),
            Expanded(
              child: institutionsAsync.when(
                loading: () => const AppLoadingIndicator(),
                error: (error, stackTrace) => AppErrorView(
                  failure: const UnknownFailure(),
                  onRetry: () => ref.invalidate(institutionsProvider),
                ),
                data: (result) => result.fold(
                  onSuccess: (institutions) {
                    if (institutions.isEmpty) {
                      return const AppEmptyState(
                        icon: AppIcons.banking,
                        message: 'Não foi possível carregar a lista de bancos.',
                      );
                    }
                    return ListView.builder(
                      itemCount: institutions.length,
                      itemBuilder: (context, index) {
                        final institution = institutions[index];
                        return ListTile(
                          leading: const Icon(AppIcons.banking),
                          title: Text(institution.name),
                          onTap: () => _link(context, ref, institution),
                        );
                      },
                    );
                  },
                  onError: (failure) => AppErrorView(
                    failure: failure,
                    onRetry: () => ref.invalidate(institutionsProvider),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
