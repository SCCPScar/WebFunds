import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/entities/search_result_type.dart';
import '../controllers/search_controller.dart';
import '../utils/search_result_presentation.dart';

/// Global search — `docs/01-Experience/09-Search.md`. Standalone route,
/// reachable from a search icon in `AppShell`'s AppBar. Debounces input
/// by 250ms (the doc's own "Search begins after 250ms") before calling
/// `SearchController.search`, which re-scans Transactions/Dreams/
/// Mysteries/Subscriptions in memory — there's no search index at this
/// app's scale.
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      ref.read(searchControllerProvider.notifier).search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onChanged,
          decoration: const InputDecoration(
            hintText: 'Pesquisar transações, objetivos, mistérios...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: switch (state) {
        SearchIdle() => const AppEmptyState(
            icon: AppIcons.search,
            message: 'Tudo numa só pesquisa. Escreve um merchant, categoria ou nome de objetivo.',
          ),
        SearchLoading() => const AppLoadingIndicator(),
        SearchFailed(:final failure) => AppErrorView(failure: failure),
        SearchSuccess(:final results) when results.isEmpty => const AppEmptyState(
            icon: AppIcons.search,
            message: 'Sem resultados. Tenta outra palavra-chave.',
          ),
        SearchSuccess(:final results) => _SearchResultsList(results: results),
      },
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  const _SearchResultsList({required this.results});

  final List<SearchResult> results;

  @override
  Widget build(BuildContext context) {
    final grouped = <SearchResultType, List<SearchResult>>{};
    for (final result in results) {
      grouped.putIfAbsent(result.type, () => []).add(result);
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        for (final type in SearchResultType.values)
          if (grouped[type] case final group?) ...[
            Text(type.groupLabel, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            for (final result in group)
              Card(
                child: ListTile(
                  leading: Icon(type.icon),
                  title: Text(result.title),
                  subtitle: Text(result.subtitle),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
          ],
      ],
    );
  }
}
