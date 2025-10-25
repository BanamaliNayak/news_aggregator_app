import 'package:aggregator_app/domain/repositories/news_repository.dart';
import 'package:aggregator_app/features/search/bloc/search_event.dart';
import 'package:aggregator_app/features/search/bloc/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

// Helper for debounce
EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) {
    return events.debounceTime(duration).switchMap(mapper);
  };
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
// region properties
  final NewsRepository repository;
// endregion

// region constructor
  SearchBloc({required this.repository}) : super(const SearchState()) {
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      // Debounce to avoid API calls on every keystroke
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<LoadMoreSearch>(_onLoadMoreSearch);
  }
// endregion

// region handlers
  Future<void> _onSearchQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty) {
      return emit(const SearchState()); // Reset to initial
    }

    emit(state.copyWith(
      status: SearchStatus.loading,
      query: event.query,
      page: 1, // Reset page
      articles: [], // Clear old results
      hasReachedMax: false,
    ));

    await _fetchResults(emit);
  }

  Future<void> _onLoadMoreSearch(
      LoadMoreSearch event, Emitter<SearchState> emit) async {
    if (state.hasReachedMax || state.status == SearchStatus.loadingMore) return;

    emit(state.copyWith(status: SearchStatus.loadingMore));
    await _fetchResults(emit);
  }
// endregion

// region helpers
  Future<void> _fetchResults(Emitter<SearchState> emit) async {
    final result = await repository.searchNews(
      query: state.query,
      page: state.page,
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: failure.message,
      )),
          (fetchResult) {
        final newArticles = fetchResult.articles;
        if (state.page == 1 && newArticles.isEmpty) {
          emit(state.copyWith(status: SearchStatus.empty));
        } else {
          emit(state.copyWith(
            status: SearchStatus.success,
            articles: List.of(state.articles)..addAll(newArticles),
            hasReachedMax: newArticles.isEmpty,
            page: state.page + 1,
          ));
        }
      },
    );
  }
// endregion
}