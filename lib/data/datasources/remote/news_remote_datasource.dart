import 'package:aggregator_app/data/models/article_model.dart';
import 'package:dio/dio.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines({
    required String category,
    required int page,
  });

  Future<List<ArticleModel>> searchNews({
    required String query,
    required int page,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
// region properties
  final Dio dio;
// endregion

// region constructor
  NewsRemoteDataSourceImpl({required this.dio});
// endregion

// region methods
  @override
  Future<List<ArticleModel>> getTopHeadlines({
    required String category,
    required int page,
  }) async {
    try {
      final response = await dio.get(
        '/everything',
        queryParameters: {
          'q': category,
          'page': page,
          'pageSize': 20,
        },
      );

      final articles = (response.data['articles'] as List)
          .map((json) =>
          ArticleModel.fromJson(json, category: category)) // Tag category
          .toList();
      return articles;
    } catch (e) {
      throw Exception('Failed to fetch top headlines: $e');
    }
  }

  @override
  Future<List<ArticleModel>> searchNews({
    required String query,
    required int page,
  }) async {
    try {
      final response = await dio.get(
        '/everything',
        queryParameters: {
          'q': query,
          'page': page,
          'pageSize': 20,
          'sortBy': 'popularity',
        },
      );

      final articles = (response.data['articles'] as List)
          .map((json) => ArticleModel.fromJson(json, category: 'search'))
          .toList();
      return articles;
    } catch (e) {
      throw Exception('Failed to search news: $e');
    }
  }
// endregion
}