import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../application/usecases/search_usecase.dart';
import '../../domain/entities/search_result.dart';
import 'search_providers.dart';

sealed class SearchState {
  const SearchState();
}

/// No query typed yet — shows Suggested Searches, not a "no results"
/// empty state.
final class SearchIdle extends SearchState {
  const SearchIdle();
}

final class SearchLoading extends SearchState {
  const SearchLoading();
}

final class SearchSuccess extends SearchState {
  const SearchSuccess(this.results);
  final List<SearchResult> results;
}

final class SearchFailed extends SearchState {
  const SearchFailed(this.failure);
  final Failure failure;
}

final searchControllerProvider =
    NotifierProvider.autoDispose<SearchController, SearchState>(SearchController.new);

class SearchController extends Notifier<SearchState> {
  @override
  SearchState build() => const SearchIdle();

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const SearchIdle();
      return;
    }

    state = const SearchLoading();
    final result = await ref.read(searchUseCaseProvider).call(SearchParams(query));

    state = switch (result) {
      Success<List<SearchResult>>(:final data) => SearchSuccess(data),
      ResultError<List<SearchResult>>(:final failure) => SearchFailed(failure),
    };
  }
}
