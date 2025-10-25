import 'package:aggregator_app/data/models/article_model.dart';
import 'package:equatable/equatable.dart';

enum NewsStatus { initial, loading, success, failure, cached, loadingMore }

class NewsState extends Equatable {
// region properties
  final NewsStatus status;
  final List<ArticleModel> articles;
  final bool hasReachedMax;
  final int page;
  final String? errorMessage;
// endregion

// region constructor
  const NewsState({
    this.status = NewsStatus.initial,
    this.articles = const <ArticleModel>[],
    this.hasReachedMax = false,
    this.page = 1,
    this.errorMessage,
  });
// endregion

// region methods
  NewsState copyWith({
    NewsStatus? status,
    List<ArticleModel>? articles,
    bool? hasReachedMax,
    int? page,
    String? errorMessage,
  }) {
    return NewsState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, articles, hasReachedMax, page, errorMessage];
// endregion
}