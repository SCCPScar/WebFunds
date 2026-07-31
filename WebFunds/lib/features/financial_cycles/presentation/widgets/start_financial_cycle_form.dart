import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/models/money.dart';
import '../../../../shared/widgets/app_text_field.dart';

class StartFinancialCycleForm extends StatefulWidget {
  const StartFinancialCycleForm({
    super.key,
    required this.onSubmit,
    required this.isLoading,
  });

  final void Function(String? name, DateTime startDate, Money openingBalance) onSubmit;
  final bool isLoading;

  @override
  State<StartFinancialCycleForm> createState() => _StartFinancialCycleFormState();
}

class _StartFinancialCycleFormState extends State<StartFinancialCycleForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  DateTime _startDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  String? _validateBalance(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final normalized = value.trim().replaceAll(',', '.');
    if (double.tryParse(normalized) == null) {
      return 'Introduz um valor válido.';
    }
    return null;
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    final rawBalance = _balanceController.text.trim().replaceAll(',', '.');
    final openingBalance = rawBalance.isEmpty
        ? Money.zero()
        : Money.fromMajorUnits(double.parse(rawBalance));

    final name = _nameController.text.trim();
    widget.onSubmit(name.isEmpty ? null : name, _startDate, openingBalance);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Novo ciclo financeiro', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(label: 'Nome (opcional)', controller: _nameController),
          const SizedBox(height: AppSpacing.lg),
          InkWell(
            onTap: widget.isLoading ? null : _pickStartDate,
            child: InputDecorator(
              decoration: const InputDecoration(labelText: 'Data de início'),
              child: Text(DateFormat('dd/MM/yyyy').format(_startDate)),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Saldo inicial (opcional)',
            controller: _balanceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            validator: _validateBalance,
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: widget.isLoading ? null : _submit,
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Iniciar ciclo'),
          ),
        ],
      ),
    );
  }
}
