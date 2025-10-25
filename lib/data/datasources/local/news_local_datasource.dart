import 'package:aggregator_app/core/database/hive_service.dart';
import 'package:aggregator_app/data/models/article_model.dart';

abstract class NewsLocalDataSource {
  Future<List<ArticleModel>> getTopHeadlines(String category);
  Future<void> cacheTopHeadlines(List<ArticleModel> articles, String category);
  Future<void> clearCache(String category);
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
// region properties
  final HiveService hive;
// endregion

// region constructor
  NewsLocalDataSourceImpl({required this.hive});
// endregion

// region methods
  @override
  Future<void> cacheTopHeadlines(
      List<ArticleModel> articles, String category) async {
    // We use the article URL as a unique key to prevent duplicates
    final articlesMap = {
      for (var article in articles) article.url: article
    };
    await hive.articlesBox.putAll(articlesMap);
  }

  @override
  Future<List<ArticleModel>> getTopHeadlines(String category) async {
    final cachedArticles = hive.articlesBox.values
        .where((article) => article.category == category)
        .toList();

    // Sort by published date, newest first
    cachedArticles.sort((a, b) =>
        (b.publishedAt ?? DateTime(0))
            .compareTo(a.publishedAt ?? DateTime(0)));
    return cachedArticles;
  }

  @override
  Future<void> clearCache(String category) async {
    final keysToRemove = hive.articlesBox.values
        .where((article) => article.category == category)
        .map((article) => article.url) // Assuming URL is the key
        .toList();

    // The key is the URL, so we fetch the article to find its key (which is its URL)
    // A bit redundant, but Hive boxes don't make "delete by value" easy.
    // A better approach would be to store keys by category in a separate box.
    // For this scope, we just find the keys.

    // Let's re-read the implementation. Ah, I'm storing by URL.
    // So the key *is* the URL.

    // Corrected logic:
    final Map<dynamic, ArticleModel> allArticles = hive.articlesBox.toMap();
    final List<dynamic> keysForCategory = [];

    allArticles.forEach((key, article) {
      if (article.category == category) {
        keysForCategory.add(key);
      }
    });

    if (keysForCategory.isNotEmpty) {
      await hive.articlesBox.deleteAll(keysForCategory);
    }
  }
// endregion
}