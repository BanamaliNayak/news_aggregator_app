import 'package:aggregator_app/data/models/article_model.dart';
import 'package:equatable/equatable.dart';

enum SearchStatus { initial, loading, success, failure, empty, loadingMore }

class SearchState extends Equatable {
// region properties
  final SearchStatus status;
  final List<ArticleModel> articles;
  final String query;
  final bool hasReachedMax;
  final int page;
  final String? errorMessage;
// endregion

// region constructor
  const SearchState({
    this.status = SearchStatus.initial,
    this.articles = const <ArticleModel>[],
    this.query = '',
    this.hasReachedMax = false,
    this.page = 1,
    this.errorMessage,
  });
// endregion

// region methods
  SearchState copyWith({
    SearchStatus? status,
    List<ArticleModel>? articles,
    String? query,
    bool? hasReachedMax,
    int? page,
    String? errorMessage,
    bool resetError = false,
  }) {
    return SearchState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      query: query ?? this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      errorMessage: resetError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, articles, query, hasReachedMax, page, errorMessage];
// endregion
}