import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/controllers/transaction_providers.dart';
import '../../application/usecases/resolve_mystery_usecase.dart';
import '../../application/usecases/update_mystery_status_usecase.dart';
import '../../domain/entities/mystery.dart';
import '../../domain/entities/mystery_status.dart';
import '../controllers/mystery_providers.dart';
import '../utils/mystery_reason_presentation.dart';

/// A dedicated workspace for Transactions that need more context —
/// `docs/01-Experience/05-Mysteries.md`. Detection runs once on mount
/// (via `mysteryDetectionProvider`); the list itself comes from
/// `mysteriesStreamProvider`, which picks up whatever detection just
/// persisted automatically.
class MysteriesPage extends ConsumerWidget {
  const MysteriesPage({super.key});

  void _openResolveSheet(
      BuildContext context, WidgetRef ref, Mystery mystery, Transaction transaction) {
    final merchantController = TextEditingController(text: transaction.merchant);
    final categoryController = TextEditingController(text: transaction.category);
    final notesController = TextEditingController(text: mystery.notes);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            top: AppSpacing.xl,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + AppSpacing.xl,
          ),
          child: Consumer(
            builder: (context, ref, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Resolver mistério', style: Theme.of(sheetContext).textTheme.headlineMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${transaction.amount.format()} · ${mystery.reason.label}',
                    style: Theme.of(sheetContext).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(label: 'Merchant', controller: merchantController),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(label: 'Categoria', controller: categoryController),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(label: 'Notas (opcional)', controller: notesController),
                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await ref.read(resolveMysteryUseCaseProvider).call(
                            ResolveMysteryParams(
                              mysteryId: mystery.id,
                              transactionId: transaction.id,
                              merchant: merchantController.text.trim().isEmpty
                                  ? null
                                  : merchantController.text.trim(),
                              category: categoryController.text.trim().isEmpty
                                  ? null
                                  : categoryController.text.trim(),
                              notes: notesController.text.trim().isEmpty
                                  ? null
                                  : notesController.text.trim(),
                            ),
                          );
                      if (!sheetContext.mounted) return;
                      result.fold(
                        onSuccess: (_) {
                          ref.invalidate(transactionByIdProvider(transaction.id));
                          Navigator.of(sheetContext).pop();
                        },
                        onError: (failure) => ScaffoldMessenger.of(sheetContext)
                            .showSnackBar(SnackBar(content: Text(failure.message))),
                      );
                    },
                    child: const Text('Resolver'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _updateStatus(WidgetRef ref, String id, MysteryStatus status) {
    return ref
        .read(updateMysteryStatusUseCaseProvider)
        .call(UpdateMysteryStatusParams(id: id, status: status));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(mysteryDetectionProvider);
    final mysteriesAsync = ref.watch(mysteriesStreamProvider);

    // No Scaffold/AppBar here — this page is a shell branch, and
    // `AppShell` already provides both (see `FinancesPage`'s reasoning).
    return mysteriesAsync.when(
      loading: () => const AppLoadingIndicator(message: 'A procurar mistérios...'),
      error: (error, stackTrace) => AppErrorView(
        failure: const UnknownFailure(),
        onRetry: () => ref.invalidate(mysteriesStreamProvider),
      ),
      data: (result) => result.fold(
        onSuccess: (mysteries) {
          final open = mysteries.where((m) => m.status == MysteryStatus.open).toList();
          final resolved = mysteries.where((m) => m.status == MysteryStatus.resolved).toList();

          if (open.isEmpty && resolved.isEmpty) {
            return const AppEmptyState(
              icon: AppIcons.mysteries,
              message: 'Ótimo! Todas as transações foram revistas.',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              Text(
                '${open.length} ${open.length == 1 ? 'mistério ativo' : 'mistérios ativos'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (open.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text('Sem mistérios por resolver.'),
                )
              else
                for (final mystery in open)
                  _MysteryCard(
                    mystery: mystery,
                    onTap: (transaction) => _openResolveSheet(context, ref, mystery, transaction),
                    onArchive: () => _updateStatus(ref, mystery.id, MysteryStatus.archived),
                  ),
              if (resolved.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xl),
                Text('Resolvidos', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                for (final mystery in resolved)
                  _ResolvedMysteryTile(
                    mystery: mystery,
                    onReopen: () => _updateStatus(ref, mystery.id, MysteryStatus.open),
                  ),
              ],
            ],
          );
        },
        onError: (failure) => AppErrorView(
          failure: failure,
          onRetry: () => ref.invalidate(mysteriesStreamProvider),
        ),
      ),
    );
  }
}

class _MysteryCard extends ConsumerWidget {
  const _MysteryCard({required this.mystery, required this.onTap, required this.onArchive});

  final Mystery mystery;
  final void Function(Transaction transaction) onTap;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync = ref.watch(transactionByIdProvider(mystery.transactionId));
    final theme = Theme.of(context);

    return transactionAsync.when(
      loading: () => const Card(child: ListTile(title: AppLoadingIndicator())),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (result) => result.fold(
        onSuccess: (transaction) {
          if (transaction == null) return const SizedBox.shrink();
          return Card(
            child: ListTile(
              leading: Icon(AppIcons.mysteries, color: theme.colorScheme.primary),
              title: Text(transaction.merchant ?? mystery.reason.label),
              subtitle: Text(mystery.reason.label),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(transaction.amount.format()),
                  IconButton(
                    icon: const Icon(AppIcons.archive),
                    tooltip: 'Arquivar',
                    onPressed: onArchive,
                  ),
                ],
              ),
              onTap: () => onTap(transaction),
            ),
          );
        },
        onError: (failure) => const SizedBox.shrink(),
      ),
    );
  }
}

class _ResolvedMysteryTile extends ConsumerWidget {
  const _ResolvedMysteryTile({required this.mystery, required this.onReopen});

  final Mystery mystery;
  final VoidCallback onReopen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync = ref.watch(transactionByIdProvider(mystery.transactionId));

    return transactionAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (result) => result.fold(
        onSuccess: (transaction) {
          if (transaction == null) return const SizedBox.shrink();
          return ListTile(
            leading: const Icon(AppIcons.check),
            title: Text(transaction.merchant ?? mystery.reason.label),
            trailing: TextButton(onPressed: onReopen, child: const Text('Reabrir')),
          );
        },
        onError: (failure) => const SizedBox.shrink(),
      ),
    );
  }
}
