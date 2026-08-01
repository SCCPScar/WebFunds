import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/models/money.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/dream_movement_type.dart';

class DreamMovementForm extends StatefulWidget {
  const DreamMovementForm({
    super.key,
    required this.type,
    required this.onSubmit,
    required this.isLoading,
  });

  final DreamMovementType type;
  final void Function(Money amount, String? notes) onSubmit;
  final bool isLoading;

  @override
  State<DreamMovementForm> createState() => _DreamMovementFormState();
}

class _DreamMovementFormState extends State<DreamMovementForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
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

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    final amount = Money.fromMajorUnits(
      double.parse(_amountController.text.trim().replaceAll(',', '.')),
    );
    widget.onSubmit(amount, _notesController.text);
  }

  @override
  Widget build(BuildContext context) {
    final isContribution = widget.type == DreamMovementType.contribution;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isContribution ? 'Contribuir para o objetivo' : 'Retirar do objetivo',
            style: Theme.of(context).textTheme.headlineMedium,
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
          AppTextField(label: 'Notas (opcional)', controller: _notesController),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: widget.isLoading ? null : _submit,
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(isContribution ? 'Contribuir' : 'Retirar'),
          ),
        ],
      ),
    );
  }
}
