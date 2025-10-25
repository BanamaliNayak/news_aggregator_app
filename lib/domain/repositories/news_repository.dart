import 'package:aggregator_app/core/utils/either.dart';
import 'package:aggregator_app/core/utils/failure.dart';
import 'package:aggregator_app/data/models/article_model.dart';

class FetchResult {
  final List<ArticleModel> articles;
  final bool isFromCache;

  FetchResult({required this.articles, this.isFromCache = false});
}

abstract class NewsRepository {
  Future<Either<Failure, FetchResult>> getTopHeadlines({
    required String category,
    required int page,
  });

  Future<Either<Failure, FetchResult>> searchNews({
    required String query,
    required int page,
  });
}