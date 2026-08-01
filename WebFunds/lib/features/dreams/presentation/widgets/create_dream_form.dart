import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/models/money.dart';
import '../../../../shared/widgets/app_text_field.dart';

class CreateDreamForm extends StatefulWidget {
  const CreateDreamForm({super.key, required this.onSubmit, required this.isLoading});

  final void Function(
    String name,
    Money targetAmount,
    String? description,
    DateTime? targetDate,
    String? category,
  ) onSubmit;
  final bool isLoading;

  @override
  State<CreateDreamForm> createState() => _CreateDreamFormState();
}

class _CreateDreamFormState extends State<CreateDreamForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  DateTime? _targetDate;

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  String? _validateTarget(String? value) {
    final normalized = (value ?? '').trim().replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed <= 0) {
      return 'Introduz um valor alvo superior a zero.';
    }
    return null;
  }

  Future<void> _pickTargetDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 10)),
    );
    if (picked != null) setState(() => _targetDate = picked);
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    final target = Money.fromMajorUnits(
      double.parse(_targetController.text.trim().replaceAll(',', '.')),
    );

    widget.onSubmit(
      _nameController.text,
      target,
      _descriptionController.text,
      _targetDate,
      _categoryController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Novo objetivo', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(label: 'Nome', controller: _nameController),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Valor alvo',
            controller: _targetController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            validator: _validateTarget,
          ),
          const SizedBox(height: AppSpacing.lg),
          InkWell(
            onTap: widget.isLoading ? null : _pickTargetDate,
            child: InputDecorator(
              decoration: const InputDecoration(labelText: 'Data alvo (opcional)'),
              child: Text(
                _targetDate == null ? 'Sem data' : DateFormat('dd/MM/yyyy').format(_targetDate!),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(label: 'Categoria (opcional)', controller: _categoryController),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(label: 'Descrição (opcional)', controller: _descriptionController),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: widget.isLoading ? null : _submit,
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Criar objetivo'),
          ),
        ],
      ),
    );
  }
}
