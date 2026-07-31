import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../router/app_routes.dart';
import '../../../../shared/models/money.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/presentation/controllers/account_providers.dart';
import '../../../accounts/presentation/utils/account_type_presentation.dart';

/// Shows a short preview of the owner's Accounts, backed by the real
/// `accountsStreamProvider` (Milestone 01.6 built the data layer; this
/// wires it into Central). Tapping the card opens the full Accounts list.
class AccountsSection extends ConsumerWidget {
  const AccountsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final accountsAsync = ref.watch(accountsStreamProvider);
    final balancesAsync = ref.watch(accountBalancesProvider);
    final balances = balancesAsync.value?.dataOrNull ?? const <String, Money>{};

    return Card(
      child: InkWell(
        onTap: () => context.push(AppRoutes.accounts),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: accountsAsync.when(
            loading: () => const AppLoadingIndicator(),
            error: (error, stackTrace) => Row(
              children: [
                Icon(AppIcons.error, color: theme.colorScheme.error),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text('Não foi possível carregar as contas', style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
            data: (result) => result.fold(
              onSuccess: (accounts) => _Content(accounts: accounts, balances: balances),
              onError: (failure) => Row(
                children: [
                  Icon(AppIcons.error, color: theme.colorScheme.error),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(failure.message, style: theme.textTheme.bodyMedium)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.accounts, required this.balances});

  final List<Account> accounts;
  final Map<String, Money> balances;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (accounts.isEmpty) {
      return Row(
        children: [
          Icon(AppIcons.finances, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text('Adiciona a tua primeira conta', style: theme.textTheme.bodyMedium),
          ),
          Icon(AppIcons.add, color: theme.colorScheme.primary),
        ],
      );
    }

    final preview = accounts.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Contas', style: theme.textTheme.titleLarge),
            const Spacer(),
            Text('Ver todas', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        for (final account in preview)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: [
                Icon(account.type.icon, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(account.name, style: theme.textTheme.bodyMedium)),
                Text(
                  (balances[account.id] ?? account.openingBalance).format(),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
