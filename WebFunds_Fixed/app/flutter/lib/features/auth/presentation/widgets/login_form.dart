import 'package:flutter/material.dart';

import '../../../../core/utils/validators.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/app_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onSubmit,
    required this.isLoading,
  });

  final void Function(String email, String password) onSubmit;
  final bool isLoading;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    widget.onSubmit(_emailController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
            autofillHints: const [AutofillHints.email],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Palavra-passe',
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: Validators.password,
            autofillHints: const [AutofillHints.password],
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? AppIcons.eyeHidden : AppIcons.eyeVisible),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
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
                : const Text('Entrar'),
          ),
        ],
      ),
    );
  }
}
