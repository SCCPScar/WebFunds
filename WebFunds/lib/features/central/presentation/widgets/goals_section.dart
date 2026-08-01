import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../router/app_routes.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../../dreams/domain/entities/dream.dart';
import '../../../dreams/presentation/controllers/dream_providers.dart';

/// Shows a short preview of the owner's Dreams, backed by the real
/// `activeDreamsStreamProvider`. Tapping the card opens the full list.
class GoalsSection extends ConsumerWidget {
  const GoalsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dreamsAsync = ref.watch(activeDreamsStreamProvider);

    return Card(
      child: InkWell(
        onTap: () => context.push(AppRoutes.dreams),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: dreamsAsync.when(
            loading: () => const AppLoadingIndicator(),
            error: (error, stackTrace) => Row(
              children: [
                Icon(AppIcons.error, color: theme.colorScheme.error),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Não foi possível carregar os objetivos',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            data: (result) => result.fold(
              onSuccess: (dreams) => _Content(dreams: dreams),
              onError: (failure) => Row(
                children: [
                  Icon(AppIcons.error, color: theme.colorScheme.error),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(failure.message, style: theme.textTheme.bodyMedium)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.dreams});

  final List<Dream> dreams;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (dreams.isEmpty) {
      return Row(
        children: [
          Icon(AppIcons.dreams, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text('Cria o teu primeiro objetivo', style: theme.textTheme.bodyMedium),
          ),
          Icon(AppIcons.add, color: theme.colorScheme.primary),
        ],
      );
    }

    final preview = dreams.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Objetivos', style: theme.textTheme.titleLarge),
            const Spacer(),
            Text(
              'Ver todos',
              style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        for (final dream in preview)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(dream.name, style: theme.textTheme.bodyMedium)),
                    Text(
                      '${(dream.progress * 100).round()}%',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: dream.progress, minHeight: 6),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
