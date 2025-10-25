import 'package:aggregator_app/core/network/connectivity_service.dart';
import 'package:aggregator_app/core/utils/either.dart';
import 'package:aggregator_app/core/utils/failure.dart';
import 'package:aggregator_app/data/datasources/local/news_local_datasource.dart';
import 'package:aggregator_app/data/datasources/remote/news_remote_datasource.dart';
import 'package:aggregator_app/domain/repositories/news_repository.dart';
import 'package:logger/logger.dart';


class NewsRepositoryImpl implements NewsRepository {
// region properties
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;
  final ConnectivityService connectivityService;
  final Logger logger;
// endregion

// region constructor
  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityService,
    required this.logger,
  });
// endregion

// region methods
  @override
  Future<Either<Failure, FetchResult>> getTopHeadlines({
    required String category,
    required int page,
  }) async {
    final bool isConnected = await connectivityService.isConnected;

    if (isConnected) {
      // --- ONLINE ---
      try {
        logger.i('Fetching from API: $category (Page $page)');
        final remoteArticles = await remoteDataSource.getTopHeadlines(
          category: category,
          page: page,
        );

        // If it's the first page (a refresh), clear old cache first
        if (page == 1) {
          await localDataSource.clearCache(category);
        }

        // Cache new articles
        await localDataSource.cacheTopHeadlines(remoteArticles, category);

        return Right(FetchResult(
          articles: remoteArticles,
          isFromCache: false,
        ));
      } catch (e) {
        logger.e('API fetch failed: $e');
        // If API fails, try to return cache as a fallback
        return _getCachedData(category, 'API Error. Showing offline data.');
      }
    } else {
      // --- OFFLINE ---
      logger.w('App is offline. Fetching from cache: $category');

      // No pagination when offline
      if (page > 1) {
        return Right(FetchResult(articles: [], isFromCache: true));
      }

      return _getCachedData(category, 'You are offline. Showing cached data.');
    }
  }

  @override
  Future<Either<Failure, FetchResult>> searchNews({
    required String query,
    required int page,
  }) async {
    final bool isConnected = await connectivityService.isConnected;

    if (isConnected) {
      // --- ONLINE ---
      try {
        logger.i('Searching API: $query (Page $page)');
        final remoteArticles = await remoteDataSource.searchNews(
          query: query,
          page: page,
        );
        // We don't cache search results
        return Right(FetchResult(
          articles: remoteArticles,
          isFromCache: false,
        ));
      } catch (e) {
        logger.e('Search failed: $e');
        return Left(Failure('Failed to perform search. Please try again.'));
      }
    } else {
      // --- OFFLINE ---
      logger.w('App is offline. Search is unavailable.');
      return Left(Failure('Search is unavailable while offline.'));
    }
  }
// endregion

// region helpers
  Future<Either<Failure, FetchResult>> _getCachedData(
      String category, String offlineMessage) async {
    try {
      final localArticles = await localDataSource.getTopHeadlines(category);
      if (localArticles.isNotEmpty) {
        return Right(FetchResult(
          articles: localArticles,
          isFromCache: true,
        ));
      } else {
        return Left(Failure('$offlineMessage (No cache found)'));
      }
    } catch (e) {
      logger.e('Cache fetch failed: $e');
      return Left(Failure('Failed to read from cache.'));
    }
  }
// endregion
}