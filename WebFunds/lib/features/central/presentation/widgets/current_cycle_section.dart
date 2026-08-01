import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/models/money.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../financial_cycles/application/usecases/close_financial_cycle_usecase.dart';
import '../../../financial_cycles/domain/entities/financial_cycle.dart';
import '../../../financial_cycles/presentation/controllers/financial_cycle_providers.dart';
import '../../../financial_cycles/presentation/controllers/start_financial_cycle_controller.dart';
import '../../../financial_cycles/presentation/widgets/start_financial_cycle_form.dart';
import '../../../reports/presentation/pages/cycle_report_page.dart';
import '../../../transactions/domain/entities/transaction_type.dart';
import '../../../transactions/presentation/controllers/transaction_providers.dart';

/// The "Current Financial Cycle" section from `docs/01-Experience/02-Central.md`
/// (name, start date, days elapsed, opening balance, income, expenses).
class CurrentCycleSection extends ConsumerWidget {
  const CurrentCycleSection({super.key});

  void _openStartForm(BuildContext context, WidgetRef ref) {
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
              final state = ref.watch(startFinancialCycleControllerProvider);

              ref.listen<StartFinancialCycleState>(startFinancialCycleControllerProvider,
                  (previous, next) {
                if (next is StartFinancialCycleFailed) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(next.failure.message)));
                }
                if (next is StartFinancialCycleSuccess) {
                  ref.read(startFinancialCycleControllerProvider.notifier).reset();
                  Navigator.of(sheetContext).pop();
                }
              });

              return StartFinancialCycleForm(
                isLoading: state is StartFinancialCycleLoading,
                onSubmit: (name, startDate, openingBalance) {
                  ref
                      .read(startFinancialCycleControllerProvider.notifier)
                      .submit(name: name, startDate: startDate, openingBalance: openingBalance);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _openCloseForm(BuildContext context, WidgetRef ref, FinancialCycle cycle) {
    final controller = TextEditingController(text: cycle.openingBalance.majorUnits.toStringAsFixed(2));
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Fechar ciclo', style: Theme.of(sheetContext).textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Saldo final',
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () async {
                  final normalized = controller.text.trim().replaceAll(',', '.');
                  final amount = double.tryParse(normalized);
                  if (amount == null) return;

                  final result = await ref.read(closeFinancialCycleUseCaseProvider).call(
                        CloseFinancialCycleParams(
                          id: cycle.id,
                          closingBalance: Money.fromMajorUnits(amount),
                        ),
                      );
                  if (!sheetContext.mounted) return;
                  result.fold(
                    onSuccess: (_) => Navigator.of(sheetContext).pop(),
                    onError: (failure) => ScaffoldMessenger.of(sheetContext)
                        .showSnackBar(SnackBar(content: Text(failure.message))),
                  );
                },
                child: const Text('Fechar ciclo'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cycleAsync = ref.watch(activeFinancialCycleStreamProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: cycleAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (error, stackTrace) => Row(
            children: [
              Icon(AppIcons.error, color: theme.colorScheme.error),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text('Não foi possível carregar o ciclo financeiro', style: theme.textTheme.bodyMedium),
              ),
            ],
          ),
          data: (result) => result.fold(
            onSuccess: (cycle) => cycle == null
                ? _NoActiveCycle(onStart: () => _openStartForm(context, ref))
                : _ActiveCycle(
                    cycle: cycle,
                    onClose: () => _openCloseForm(context, ref, cycle),
                  ),
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
    );
  }
}

class _NoActiveCycle extends StatelessWidget {
  const _NoActiveCycle({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(AppIcons.activity, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text('Nenhum ciclo financeiro ativo', style: theme.textTheme.bodyMedium),
        ),
        TextButton(onPressed: onStart, child: const Text('Iniciar ciclo')),
      ],
    );
  }
}

class _ActiveCycle extends ConsumerWidget {
  const _ActiveCycle({required this.cycle, required this.onClose});

  final FinancialCycle cycle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final daysSinceStart = DateTime.now().difference(cycle.startDate).inDays;
    final displayName = cycle.name ?? 'Ciclo desde ${DateFormat('dd/MM/yyyy').format(cycle.startDate)}';
    final transactionsAsync = ref.watch(transactionsByCycleStreamProvider(cycle.id));
    final transactions = transactionsAsync.value?.dataOrNull ?? const [];
    final income = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(Money.zero(), (sum, t) => sum + t.amount);
    final expenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(Money.zero(), (sum, t) => sum + t.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(displayName, style: theme.textTheme.titleLarge)),
            TextButton(onPressed: onClose, child: const Text('Fechar ciclo')),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          daysSinceStart == 0 ? 'Iniciado hoje' : 'Há $daysSinceStart dias',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text('Saldo inicial: ${cycle.openingBalance.format()}', style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Receitas: ${income.format()}  ·  Despesas: ${expenses.format()}',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(builder: (_) => CycleReportPage(cycle: cycle)),
            ),
            child: const Text('Ver relatório'),
          ),
        ),
      ],
    );
  }
}
