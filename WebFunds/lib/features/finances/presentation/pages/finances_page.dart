import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/failure.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../router/app_routes.dart';
import '../../../../services/logging/app_logger.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/presentation/controllers/account_providers.dart';
import '../../../financial_cycles/domain/entities/financial_cycle.dart';
import '../../../financial_cycles/presentation/controllers/financial_cycle_providers.dart';
import '../../../financial_cycles/presentation/controllers/start_financial_cycle_controller.dart';
import '../../../financial_cycles/presentation/widgets/start_financial_cycle_form.dart';
import '../../../transactions/application/usecases/update_transaction_merchant_category_usecase.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/controllers/create_transaction_controller.dart';
import '../../../transactions/presentation/controllers/transaction_providers.dart';
import '../../../transactions/presentation/widgets/create_transaction_form.dart';
import '../../../transactions/presentation/widgets/transaction_list_tile.dart';

/// Transactions are always viewed grouped by the active Financial Cycle
/// (`docs/01-Experience/03-Finances.md`), so this screen needs one before
/// it can show or add anything — reuses the same "start a cycle" flow
/// `CurrentCycleSection` offers on Central.
class FinancesPage extends ConsumerWidget {
  const FinancesPage({super.key});

  void _openStartCycleForm(BuildContext context, WidgetRef ref) {
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

  void _openCreateTransactionForm(
    BuildContext context,
    WidgetRef ref,
    FinancialCycle cycle,
    List<Account> accounts,
  ) {
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
              final state = ref.watch(createTransactionControllerProvider);

              ref.listen<CreateTransactionState>(createTransactionControllerProvider,
                  (previous, next) {
                if (next is CreateTransactionFailed) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(next.failure.message)));
                }
                if (next is CreateTransactionSuccess) {
                  ref.read(createTransactionControllerProvider.notifier).reset();
                  Navigator.of(sheetContext).pop();
                }
              });

              return CreateTransactionForm(
                accounts: accounts,
                isLoading: state is CreateTransactionLoading,
                onSubmit: (type, amount, accountId, transactionDate, merchant, category) {
                  ref.read(createTransactionControllerProvider.notifier).submit(
                        financialCycleId: cycle.id,
                        accountId: accountId,
                        type: type,
                        amount: amount,
                        transactionDate: transactionDate,
                        merchant: merchant,
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

  void _openEditForm(BuildContext context, WidgetRef ref, Transaction transaction) {
    final merchantController = TextEditingController(text: transaction.merchant);
    final categoryController = TextEditingController(text: transaction.category);
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
              Text('Editar transação', style: Theme.of(sheetContext).textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(label: 'Merchant', controller: merchantController),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(label: 'Categoria', controller: categoryController),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () async {
                  final result =
                      await ref.read(updateTransactionMerchantCategoryUseCaseProvider).call(
                            UpdateTransactionMerchantCategoryParams(
                              id: transaction.id,
                              merchant: merchantController.text.trim().isEmpty
                                  ? null
                                  : merchantController.text.trim(),
                              category: categoryController.text.trim().isEmpty
                                  ? null
                                  : categoryController.text.trim(),
                            ),
                          );
                  if (!sheetContext.mounted) return;
                  result.fold(
                    onSuccess: (_) => Navigator.of(sheetContext).pop(),
                    onError: (failure) => ScaffoldMessenger.of(sheetContext)
                        .showSnackBar(SnackBar(content: Text(failure.message))),
                  );
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleAsync = ref.watch(activeFinancialCycleStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finanças'),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.subscriptions),
            tooltip: 'Subscrições',
            onPressed: () => context.push(AppRoutes.subscriptions),
          ),
        ],
      ),
      body: cycleAsync.when(
        loading: () => const AppLoadingIndicator(message: 'A carregar o ciclo financeiro...'),
        error: (error, stackTrace) {
          ref.read(appLoggerProvider).error(
            'Falha inesperada ao carregar o ciclo financeiro.',
            tag: 'FinancesPage',
            error: error,
            stackTrace: stackTrace,
          );
          return AppErrorView(
            failure: const UnknownFailure(),
            onRetry: () => ref.invalidate(activeFinancialCycleStreamProvider),
          );
        },
        data: (result) => result.fold(
          onSuccess: (cycle) => cycle == null
              ? AppEmptyState(
                  icon: AppIcons.finances,
                  message:
                      'Precisas de um ciclo financeiro ativo para veres e adicionares transações.',
                  action: ElevatedButton(
                    onPressed: () => _openStartCycleForm(context, ref),
                    child: const Text('Iniciar ciclo'),
                  ),
                )
              : _CycleTransactions(
                  cycle: cycle,
                  onAddTransaction: (accounts) =>
                      _openCreateTransactionForm(context, ref, cycle, accounts),
                  onEditTransaction: (transaction) => _openEditForm(context, ref, transaction),
                ),
          onError: (failure) => AppErrorView(
            failure: failure,
            onRetry: () => ref.invalidate(activeFinancialCycleStreamProvider),
          ),
        ),
      ),
    );
  }
}

class _CycleTransactions extends ConsumerWidget {
  const _CycleTransactions({
    required this.cycle,
    required this.onAddTransaction,
    required this.onEditTransaction,
  });

  final FinancialCycle cycle;
  final void Function(List<Account> accounts) onAddTransaction;
  final void Function(Transaction transaction) onEditTransaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsByCycleStreamProvider(cycle.id));
    final accountsAsync = ref.watch(accountsStreamProvider);
    final accounts = accountsAsync.value?.dataOrNull ?? const <Account>[];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => onAddTransaction(accounts),
        tooltip: 'Adicionar transação',
        child: const Icon(AppIcons.add),
      ),
      body: transactionsAsync.when(
        loading: () => const AppLoadingIndicator(message: 'A carregar transações...'),
        error: (error, stackTrace) {
          ref.read(appLoggerProvider).error(
            'Falha inesperada ao carregar as transações.',
            tag: 'FinancesPage',
            error: error,
            stackTrace: stackTrace,
          );
          return AppErrorView(
            failure: const UnknownFailure(),
            onRetry: () => ref.invalidate(transactionsByCycleStreamProvider(cycle.id)),
          );
        },
        data: (result) => result.fold(
          onSuccess: (transactions) {
            if (transactions.isEmpty) {
              return const AppEmptyState(
                icon: AppIcons.finances,
                message: 'Ainda não há transações neste ciclo.',
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.xl),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return TransactionListTile(
                  transaction: transaction,
                  onTap: () => onEditTransaction(transaction),
                );
              },
            );
          },
          onError: (failure) => AppErrorView(
            failure: failure,
            onRetry: () => ref.invalidate(transactionsByCycleStreamProvider(cycle.id)),
          ),
        ),
      ),
    );
  }
}
