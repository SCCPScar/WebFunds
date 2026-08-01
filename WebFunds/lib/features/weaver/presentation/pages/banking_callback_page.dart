import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/failure.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../router/app_routes.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../controllers/banking_providers.dart';

/// The real route Enable Banking's redirect lands on, after
/// `web/banking/callback.html` hands off its query parameters here
/// (`?code=...`, possibly `&state=...`, `&error=...`). Exchanges the code
/// for the linked Accounts and reports the result.
class BankingCallbackPage extends ConsumerStatefulWidget {
  const BankingCallbackPage({super.key, required this.code});

  final String? code;

  @override
  ConsumerState<BankingCallbackPage> createState() => _BankingCallbackPageState();
}

class _BankingCallbackPageState extends ConsumerState<BankingCallbackPage> {
  Failure? _failure;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _complete());
  }

  Future<void> _complete() async {
    final code = widget.code;
    if (code == null || code.isEmpty) {
      setState(() => _failure = const UnknownFailure(message: 'Ligação ao banco cancelada.'));
      return;
    }

    final result = await ref.read(completeBankLinkUseCaseProvider).call(code);
    if (!mounted) return;
    result.fold(
      onSuccess: (_) => setState(() => _completed = true),
      onError: (failure) => setState(() => _failure = failure),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Banking')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_failure != null) {
      return AppErrorView(
        failure: _failure!,
        onRetry: () => context.go(AppRoutes.banking),
      );
    }
    if (_completed) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Conta bancária ligada com sucesso.'),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () => context.go(AppRoutes.banking),
            child: const Text('Ver contas'),
          ),
        ],
      );
    }
    return const AppLoadingIndicator(message: 'A ligar a tua conta...');
  }
}
