import 'package:aggregator_app/domain/repositories/news_repository.dart';
import 'package:aggregator_app/features/home/bloc/news_event.dart';
import 'package:aggregator_app/features/home/bloc/news_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class NewsBloc extends Bloc<NewsEvent, NewsState> {
// region properties
  final
  NewsRepository repository;
// endregion

// region constructor
  NewsBloc({required this.repository}) : super(const NewsState()) {
    on<FetchNews>(_onFetchNews);
    on<RefreshNews>(_onRefreshNews);
  }
// endregion

// region handlers
  Future<void> _onFetchNews(FetchNews event, Emitter<NewsState> emit) async {
    if (state.hasReachedMax) return;

    if (state.status == NewsStatus.initial) {
      emit(state.copyWith(status: NewsStatus.loading));
    } else {
      emit(state.copyWith(status: NewsStatus.loadingMore));
    }

    final result = await repository.getTopHeadlines(
      category: event.category,
      page: state.page,
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: NewsStatus.failure,
        errorMessage: failure.message,
      )),
          (fetchResult) {
        final newArticles = fetchResult.articles;
        final isFromCache = fetchResult.isFromCache;

        emit(state.copyWith(
          status: isFromCache ? NewsStatus.cached : NewsStatus.success,
          articles: List.of(state.articles)..addAll(newArticles),
          hasReachedMax: newArticles.isEmpty,
          page: state.page + 1,
        ));
      },
    );
  }

  Future<void> _onRefreshNews(RefreshNews event, Emitter<NewsState> emit) async {
    // Reset state before fetching
    emit(const NewsState(status: NewsStatus.loading));

    // Slight delay to allow pull-to-refresh indicator to show
    await Future.delayed(const Duration(milliseconds: 500));

    final result = await repository.getTopHeadlines(
      category: event.category,
      page: 1, // Always page 1 for refresh
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: NewsStatus.failure,
        errorMessage: failure.message,
      )),
          (fetchResult) {
        emit(NewsState( // Create a new state, not copyWith
          status: fetchResult.isFromCache ? NewsStatus.cached : NewsStatus.success,
          articles: fetchResult.articles,
          hasReachedMax: fetchResult.articles.isEmpty,
          page: 2, // Next page to fetch is 2
        ));
      },
    );
  }
// endregion
}