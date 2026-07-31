import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../services/logging/app_logger.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../domain/entities/account.dart';
import '../controllers/account_providers.dart';
import '../controllers/create_account_controller.dart';
import '../widgets/account_list_tile.dart';
import '../widgets/create_account_form.dart';

/// Lists Accounts and lets the owner create or archive one. Consumes the
/// already-existing `accountsStreamProvider` — no new data plumbing here,
/// only presentation.
class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  Future<void> _archive(BuildContext context, WidgetRef ref, String accountId) async {
    final result = await ref.read(archiveAccountUseCaseProvider).call(accountId);
    if (!context.mounted) return;
    result.fold(
      onSuccess: (_) {},
      onError: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
      },
    );
  }

  void _openCreateForm(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            top: AppSpacing.xl,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + AppSpacing.xl,
          ),
          child: Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(createAccountControllerProvider);

              ref.listen<CreateAccountState>(createAccountControllerProvider, (previous, next) {
                if (next is CreateAccountFailed) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(next.failure.message)));
                }
                if (next is CreateAccountSuccess) {
                  ref.read(createAccountControllerProvider.notifier).reset();
                  Navigator.of(sheetContext).pop();
                }
              });

              return CreateAccountForm(
                isLoading: state is CreateAccountLoading,
                onSubmit: (name, type, openingBalance) {
                  ref
                      .read(createAccountControllerProvider.notifier)
                      .submit(name: name, type: type, openingBalance: openingBalance);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Contas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateForm(context, ref),
        tooltip: 'Adicionar conta',
        child: const Icon(AppIcons.add),
      ),
      body: accountsAsync.when(
        loading: () => const AppLoadingIndicator(message: 'A carregar as tuas contas...'),
        error: (error, stackTrace) {
          ref.read(appLoggerProvider).error(
            'Falha inesperada ao carregar as contas.',
            tag: 'AccountsPage',
            error: error,
            stackTrace: stackTrace,
          );
          return AppErrorView(
            failure: const UnknownFailure(),
            onRetry: () => ref.invalidate(accountsStreamProvider),
          );
        },
        data: (result) => result.fold(
          onSuccess: (accounts) => _AccountsList(
            accounts: accounts,
            onArchive: (id) => _archive(context, ref, id),
          ),
          onError: (failure) => AppErrorView(
            failure: failure,
            onRetry: () => ref.invalidate(accountsStreamProvider),
          ),
        ),
      ),
    );
  }
}

class _AccountsList extends StatelessWidget {
  const _AccountsList({required this.accounts, required this.onArchive});

  final List<Account> accounts;
  final void Function(String accountId) onArchive;

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return const AppEmptyState(
        icon: AppIcons.finances,
        message: 'Ainda não tens contas. Adiciona a primeira para começares a acompanhar o teu saldo.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.xl),
      itemCount: accounts.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final account = accounts[index];
        return AccountListTile(
          account: account,
          onArchive: () => onArchive(account.id),
        );
      },
    );
  }
}
