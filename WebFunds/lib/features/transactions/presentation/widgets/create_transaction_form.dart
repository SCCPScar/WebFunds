import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/models/money.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../weaver/presentation/controllers/suggest_category_controller.dart';
import '../../domain/entities/transaction_type.dart';
import '../utils/transaction_type_presentation.dart';

class CreateTransactionForm extends ConsumerStatefulWidget {
  const CreateTransactionForm({
    super.key,
    required this.accounts,
    required this.onSubmit,
    required this.isLoading,
  });

  final List<Account> accounts;
  final bool isLoading;
  final void Function(
    TransactionType type,
    Money amount,
    String accountId,
    DateTime transactionDate,
    String? merchant,
    String? category,
  ) onSubmit;

  @override
  ConsumerState<CreateTransactionForm> createState() => _CreateTransactionFormState();
}

class _CreateTransactionFormState extends ConsumerState<CreateTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _categoryController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  DateTime _transactionDate = DateTime.now();
  String? _accountId;

  @override
  void initState() {
    super.initState();
    _accountId = widget.accounts.isEmpty ? null : widget.accounts.first.id;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  String? _validateAmount(String? value) {
    final normalized = (value ?? '').trim().replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed <= 0) {
      return 'Introduz um valor superior a zero.';
    }
    return null;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _transactionDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _transactionDate = picked);
  }

  void _requestCategorySuggestion() {
    final normalized = _amountController.text.trim().replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduz um valor antes de pedir uma sugestão.')),
      );
      return;
    }

    final merchant = _merchantController.text.trim();
    ref.read(suggestCategoryControllerProvider.notifier).request(
          type: _type,
          amount: Money.fromMajorUnits(parsed),
          merchant: merchant.isEmpty ? null : merchant,
        );
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    if (_accountId == null) return;

    final amount = Money.fromMajorUnits(
      double.parse(_amountController.text.trim().replaceAll(',', '.')),
    );

    widget.onSubmit(
      _type,
      amount,
      _accountId!,
      _transactionDate,
      _merchantController.text,
      _categoryController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.accounts.isEmpty) {
      return Text(
        'Precisas de ter pelo menos uma conta para adicionares uma transação.',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    final suggestionState = ref.watch(suggestCategoryControllerProvider);

    ref.listen<SuggestCategoryState>(suggestCategoryControllerProvider, (previous, next) {
      if (next is SuggestCategoryEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('A Weaver AI não teve uma sugestão desta vez.')));
        ref.read(suggestCategoryControllerProvider.notifier).reset();
      }
      if (next is SuggestCategoryFailed) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.failure.message)));
        ref.read(suggestCategoryControllerProvider.notifier).reset();
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Nova transação', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.lg),
          SegmentedButton<TransactionType>(
            segments: TransactionType.values
                .map((type) => ButtonSegment(value: type, label: Text(type.label)))
                .toList(),
            selected: {_type},
            onSelectionChanged: (selection) => setState(() => _type = selection.first),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Valor',
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            validator: _validateAmount,
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<String>(
            initialValue: _accountId,
            decoration: const InputDecoration(labelText: 'Conta'),
            items: widget.accounts
                .map((account) => DropdownMenuItem(value: account.id, child: Text(account.name)))
                .toList(),
            onChanged: (value) => setState(() => _accountId = value),
          ),
          const SizedBox(height: AppSpacing.lg),
          InkWell(
            onTap: widget.isLoading ? null : _pickDate,
            child: InputDecorator(
              decoration: const InputDecoration(labelText: 'Data'),
              child: Text(DateFormat('dd/MM/yyyy').format(_transactionDate)),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(label: 'Merchant (opcional)', controller: _merchantController),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(label: 'Categoria (opcional)', controller: _categoryController),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: suggestionState is SuggestCategoryLoading || widget.isLoading
                  ? null
                  : _requestCategorySuggestion,
              icon: suggestionState is SuggestCategoryLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome, size: 18),
              label: const Text('Pedir sugestão à Weaver AI'),
            ),
          ),
          if (suggestionState is SuggestCategorySuccess) ...[
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sugestão: ${suggestionState.suggestion.category}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (suggestionState.suggestion.reasoning.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        suggestionState.suggestion.reasoning,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xs),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          _categoryController.text = suggestionState.suggestion.category;
                          ref.read(suggestCategoryControllerProvider.notifier).reset();
                        },
                        child: const Text('Usar esta sugestão'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: widget.isLoading ? null : _submit,
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Adicionar transação'),
          ),
        ],
      ),
    );
  }
}
