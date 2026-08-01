import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/use_case.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../theme/theme_mode_provider.dart';
import '../../../auth/presentation/controllers/auth_providers.dart';
import '../controllers/onboarding_providers.dart';

/// The first-launch flow — `docs/01-Experience/10-Onboarding.md`. Follows
/// the doc's own flow minus everything that depends on Banking (Connect
/// Bank, Account Review, Initial Synchronization, Initial Scan): this app
/// has no bank sync yet, so those steps would have nothing real to show.
/// What's left maps directly to the doc's Welcome, Introduction, Security
/// and Preferences steps, plus a combined Weaver Introduction + Finish
/// step. Gated by `onboardingCompleteProvider`/`AppNavigationResolver` —
/// shown once, right after the first successful login.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _pageCount = 5;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  Future<void> _finish() async {
    final result = await ref.read(completeOnboardingUseCaseProvider).call(const NoParams());
    result.fold(
      onSuccess: (_) => ref.read(onboardingCompleteProvider.notifier).set(true),
      // Fail open — a storage error here should never trap the owner on
      // this screen forever.
      onError: (_) => ref.read(onboardingCompleteProvider.notifier).set(true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pageCount - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: const [
                  _WelcomeStep(),
                  _IntroductionStep(),
                  _SecurityStep(),
                  _PreferencesStep(),
                  _WeaverFinishStep(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < _pageCount; i++)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == _currentPage
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surfaceContainerHighest,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLastPage ? _finish : _next,
                      child: Text(isLastPage ? 'Abrir Central' : 'Seguinte'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.lg),
          ...children,
        ],
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep();

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      icon: AppIcons.central,
      title: 'Bem-vindo ao WebFunds',
      children: const [
        Text('A tua história financeira começa aqui.'),
      ],
    );
  }
}

class _IntroductionStep extends StatelessWidget {
  const _IntroductionStep();

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      icon: AppIcons.finances,
      title: 'Como funciona',
      children: const [
        Text('O WebFunds ajuda-te a perceber o teu dinheiro.'),
        SizedBox(height: AppSpacing.md),
        Text('Não controla as tuas contas bancárias.'),
        SizedBox(height: AppSpacing.md),
        Text('Nunca move dinheiro.'),
        SizedBox(height: AppSpacing.md),
        Text('Só analisa a tua informação financeira.'),
      ],
    );
  }
}

class _SecurityStep extends ConsumerWidget {
  const _SecurityStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricAsync = ref.watch(_biometricPreferenceProvider);

    return _StepScaffold(
      icon: AppIcons.biometric,
      title: 'Segurança',
      children: [
        const Text('Os teus dados ficam guardados de forma segura neste dispositivo.'),
        const SizedBox(height: AppSpacing.lg),
        Card(
          child: biometricAsync.when(
            loading: () => const SizedBox(
              height: 56,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => const SizedBox.shrink(),
            data: (result) => SwitchListTile(
              title: const Text('Usar Face ID / biometria'),
              subtitle: const Text('Opcional — podes ativar isto mais tarde no Perfil.'),
              value: result.dataOrNull ?? false,
              onChanged: (value) async {
                await ref.read(setBiometricPreferenceUseCaseProvider).call(value);
                ref.invalidate(_biometricPreferenceProvider);
              },
            ),
          ),
        ),
      ],
    );
  }
}

final _biometricPreferenceProvider = FutureProvider.autoDispose((ref) {
  return ref.read(getBiometricPreferenceUseCaseProvider).call(const NoParams());
});

class _PreferencesStep extends ConsumerWidget {
  const _PreferencesStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return _StepScaffold(
      icon: AppIcons.profile,
      title: 'Preferências',
      children: [
        const Text('Aparência'),
        const SizedBox(height: AppSpacing.sm),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(value: ThemeMode.system, label: Text('Sistema')),
            ButtonSegment(value: ThemeMode.light, label: Text('Claro')),
            ButtonSegment(value: ThemeMode.dark, label: Text('Escuro')),
          ],
          selected: {themeMode},
          onSelectionChanged: (selection) =>
              ref.read(themeModeProvider.notifier).setThemeMode(selection.first),
        ),
      ],
    );
  }
}

class _WeaverFinishStep extends StatelessWidget {
  const _WeaverFinishStep();

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      icon: AppIcons.weaver,
      title: 'Conhece o Weaver',
      children: const [
        Text('O Weaver sugere.'),
        SizedBox(height: AppSpacing.md),
        Text('O Weaver aprende com o tempo.'),
        SizedBox(height: AppSpacing.md),
        Text('O Weaver nunca age sozinho — tu decides sempre.'),
        SizedBox(height: AppSpacing.lg),
        Text('Tudo pronto. Vamos começar.'),
      ],
    );
  }
}
