import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/failure.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../services/logging/app_logger.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../domain/entities/dream.dart';
import '../../domain/entities/dream_movement_type.dart';
import '../controllers/create_dream_controller.dart';
import '../controllers/dream_movement_controller.dart';
import '../controllers/dream_providers.dart';
import '../utils/dream_movement_type_presentation.dart';
import '../widgets/create_dream_form.dart';
import '../widgets/dream_list_tile.dart';
import '../widgets/dream_movement_form.dart';

/// Lists Dreams and lets the owner create one, contribute, or withdraw —
/// same structure `AccountsPage`/`FinancesPage` established.
class DreamsPage extends ConsumerWidget {
  const DreamsPage({super.key});

  void _openCreateForm(BuildContext context, WidgetRef ref) {
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
              final state = ref.watch(createDreamControllerProvider);

              ref.listen<CreateDreamState>(createDreamControllerProvider, (previous, next) {
                if (next is CreateDreamFailed) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(next.failure.message)));
                }
                if (next is CreateDreamSuccess) {
                  ref.read(createDreamControllerProvider.notifier).reset();
                  Navigator.of(sheetContext).pop();
                }
              });

              return CreateDreamForm(
                isLoading: state is CreateDreamLoading,
                onSubmit: (name, targetAmount, description, targetDate, category) {
                  ref.read(createDreamControllerProvider.notifier).submit(
                        name: name,
                        targetAmount: targetAmount,
                        description: description,
                        targetDate: targetDate,
                        category: category,
                      );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _openDreamDetail(BuildContext context, WidgetRef ref, Dream dream) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          builder: (context, scrollController) {
            return _DreamDetailSheet(dream: dream, scrollController: scrollController);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dreamsAsync = ref.watch(activeDreamsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Objetivos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateForm(context, ref),
        tooltip: 'Adicionar objetivo',
        child: const Icon(AppIcons.add),
      ),
      body: dreamsAsync.when(
        loading: () => const AppLoadingIndicator(message: 'A carregar os teus objetivos...'),
        error: (error, stackTrace) {
          ref.read(appLoggerProvider).error(
            'Falha inesperada ao carregar os objetivos.',
            tag: 'DreamsPage',
            error: error,
            stackTrace: stackTrace,
          );
          return AppErrorView(
            failure: const UnknownFailure(),
            onRetry: () => ref.invalidate(activeDreamsStreamProvider),
          );
        },
        data: (result) => result.fold(
          onSuccess: (dreams) {
            if (dreams.isEmpty) {
              return const AppEmptyState(
                icon: AppIcons.dreams,
                message: 'Ainda não tens objetivos. Cria o primeiro e começa a reservar dinheiro.',
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.xl),
              itemCount: dreams.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final dream = dreams[index];
                return DreamListTile(
                  dream: dream,
                  onTap: () => _openDreamDetail(context, ref, dream),
                );
              },
            );
          },
          onError: (failure) => AppErrorView(
            failure: failure,
            onRetry: () => ref.invalidate(activeDreamsStreamProvider),
          ),
        ),
      ),
    );
  }
}

class _DreamDetailSheet extends ConsumerWidget {
  const _DreamDetailSheet({required this.dream, required this.scrollController});

  final Dream dream;
  final ScrollController scrollController;

  void _openMovementForm(BuildContext context, WidgetRef ref, DreamMovementType type) {
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
              final state = ref.watch(dreamMovementControllerProvider);

              ref.listen<DreamMovementState>(dreamMovementControllerProvider, (previous, next) {
                if (next is DreamMovementFailed) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(next.failure.message)));
                }
                if (next is DreamMovementSuccess) {
                  ref.read(dreamMovementControllerProvider.notifier).reset();
                  Navigator.of(sheetContext).pop();
                }
              });

              return DreamMovementForm(
                type: type,
                isLoading: state is DreamMovementLoading,
                onSubmit: (amount, notes) {
                  ref.read(dreamMovementControllerProvider.notifier).submit(
                        dreamId: dream.id,
                        type: type,
                        amount: amount,
                        notes: notes,
                      );
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
    final theme = Theme.of(context);
    final movementsAsync = ref.watch(dreamMovementsStreamProvider(dream.id));

    // Watches the live Dream instead of only ever showing the snapshot
    // passed in when the sheet was opened, so the progress bar updates
    // the instant a contribution/withdrawal lands. Falls back to that
    // snapshot while loading/on error rather than blocking the sheet.
    final liveDream =
        ref.watch(dreamByIdStreamProvider(dream.id)).value?.dataOrNull ?? dream;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        Text(liveDream.name, style: theme.textTheme.headlineMedium),
        if (liveDream.description != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(liveDream.description!, style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: AppSpacing.lg),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: liveDream.progress, minHeight: 10),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '${liveDream.reservedAmount.format()} de ${liveDream.targetAmount.format()} reservado',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () =>
                    _openMovementForm(context, ref, DreamMovementType.contribution),
                child: const Text('Contribuir'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _openMovementForm(context, ref, DreamMovementType.withdrawal),
                child: const Text('Retirar'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Histórico', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        movementsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: AppLoadingIndicator(),
          ),
          error: (error, stackTrace) => Text(
            'Não foi possível carregar o histórico.',
            style: theme.textTheme.bodySmall,
          ),
          data: (result) => result.fold(
            onSuccess: (movements) {
              if (movements.isEmpty) {
                return Text('Ainda sem movimentos.', style: theme.textTheme.bodySmall);
              }
              return Column(
                children: [
                  for (final movement in movements)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        movement.type == DreamMovementType.contribution
                            ? AppIcons.add
                            : AppIcons.dreamWithdraw,
                      ),
                      title: Text(movement.type.label),
                      subtitle: movement.notes != null ? Text(movement.notes!) : null,
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(movement.amount.format()),
                          Text(
                            DateFormat('dd/MM/yyyy').format(movement.date),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
            onError: (failure) =>
                Text(failure.message, style: theme.textTheme.bodySmall),
          ),
        ),
      ],
    );
  }
}
