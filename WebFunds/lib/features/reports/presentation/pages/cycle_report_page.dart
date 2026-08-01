import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/result/result.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/models/money.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../../financial_cycles/domain/entities/financial_cycle.dart';
import '../../domain/entities/category_breakdown_entry.dart';
import '../../domain/entities/cycle_report.dart';
import '../controllers/report_providers.dart';

/// The Financial Cycle Report — a one-shot computation over the Cycle's
/// Transactions, so this reads the Use Case directly via a `Future`
/// rather than going through a Riverpod provider: nothing else in the
/// app needs to watch or cache one Cycle's report.
class CycleReportPage extends ConsumerStatefulWidget {
  const CycleReportPage({super.key, required this.cycle});

  final FinancialCycle cycle;

  @override
  ConsumerState<CycleReportPage> createState() => _CycleReportPageState();
}

class _CycleReportPageState extends ConsumerState<CycleReportPage> {
  late Future<Result<CycleReport>> _reportFuture;

  @override
  void initState() {
    super.initState();
    _reportFuture = ref.read(getCycleReportUseCaseProvider).call(widget.cycle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatório do ciclo')),
      body: FutureBuilder<Result<CycleReport>>(
        future: _reportFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const AppLoadingIndicator(message: 'A calcular o relatório...');
          }
          return snapshot.data!.fold(
            onSuccess: (report) => _CycleReportView(report: report),
            onError: (failure) => AppErrorView(failure: failure),
          );
        },
      ),
    );
  }
}

class _CycleReportView extends StatelessWidget {
  const _CycleReportView({required this.report});

  final CycleReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        Text(
          report.cycle.name ??
              'Ciclo desde ${DateFormat('dd/MM/yyyy').format(report.cycle.startDate)}',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        _SummaryRow(
          totalIncome: report.totalIncome,
          totalExpenses: report.totalExpenses,
          net: report.net,
        ),
        if (report.previousCycleIncome != null || report.previousCycleExpenses != null) ...[
          const SizedBox(height: AppSpacing.lg),
          _PreviousCycleComparison(report: report),
        ],
        if (report.largestExpense != null || report.largestIncome != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Maiores movimentos', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          if (report.largestExpense != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(report.largestExpense!.merchant ?? 'Maior despesa'),
              subtitle: const Text('Maior despesa'),
              trailing: Text(report.largestExpense!.amount.format()),
            ),
          if (report.largestIncome != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(report.largestIncome!.merchant ?? 'Maior receita'),
              subtitle: const Text('Maior receita'),
              trailing: Text(report.largestIncome!.amount.format()),
            ),
        ],
        if (report.categoryBreakdown.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Por categoria', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          for (final entry in report.categoryBreakdown) _CategoryRow(entry: entry),
        ],
        if (report.merchantBreakdown.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Por merchant', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          for (final entry in report.merchantBreakdown)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(entry.merchant),
              subtitle: Text('${entry.visits} ${entry.visits == 1 ? 'compra' : 'compras'}'),
              trailing: Text(entry.total.format()),
            ),
        ],
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.totalIncome, required this.totalExpenses, required this.net});

  final Money totalIncome;
  final Money totalExpenses;
  final Money net;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: _StatCard(label: 'Receitas', value: totalIncome.format(), color: theme.colorScheme.primary),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatCard(label: 'Despesas', value: totalExpenses.format(), color: theme.colorScheme.error),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: _StatCard(label: 'Saldo', value: net.format())),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodySmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviousCycleComparison extends StatelessWidget {
  const _PreviousCycleComparison({required this.report});

  final CycleReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final previousExpenses = report.previousCycleExpenses;
    final expensesDiff = previousExpenses == null ? null : report.totalExpenses - previousExpenses;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Comparação com o ciclo anterior', style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            if (expensesDiff != null)
              Text(
                expensesDiff.isNegative
                    ? 'Despesas ${expensesDiff.abs().format()} mais baixas'
                    : expensesDiff.isZero
                        ? 'Despesas iguais ao ciclo anterior'
                        : 'Despesas ${expensesDiff.format()} mais altas',
                style: theme.textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.entry});

  final CategoryBreakdownEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(entry.category, style: theme.textTheme.bodyMedium)),
              Text(entry.total.format(), style: theme.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: entry.percentage, minHeight: 6),
          ),
        ],
      ),
    );
  }
}
