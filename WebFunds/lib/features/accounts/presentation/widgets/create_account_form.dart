import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/models/money.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/account_type.dart';
import '../utils/account_type_presentation.dart';

class CreateAccountForm extends StatefulWidget {
  const CreateAccountForm({
    super.key,
    required this.onSubmit,
    required this.isLoading,
  });

  final void Function(String name, AccountType type, Money openingBalance) onSubmit;
  final bool isLoading;

  @override
  State<CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  AccountType _type = AccountType.checking;

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

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    final rawBalance = _balanceController.text.trim().replaceAll(',', '.');
    final openingBalance = rawBalance.isEmpty
        ? Money.zero()
        : Money.fromMajorUnits(double.parse(rawBalance));

    widget.onSubmit(_nameController.text, _type, openingBalance);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Nova conta', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Nome',
            controller: _nameController,
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'O nome da conta é obrigatório.' : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<AccountType>(
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Tipo de conta'),
            items: AccountType.values
                .map((type) => DropdownMenuItem(value: type, child: Text(type.label)))
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _type = value);
            },
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
                : const Text('Criar conta'),
          ),
        ],
      ),
    );
  }
}
