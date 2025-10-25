import 'package:aggregator_app/core/config/api_config.dart';
import 'package:aggregator_app/core/constants/hive_constants.dart';
import 'package:aggregator_app/core/database/hive_service.dart';
import 'package:aggregator_app/core/network/connectivity_service.dart';
import 'package:aggregator_app/core/network/dio_client.dart';
import 'package:aggregator_app/data/datasources/local/news_local_datasource.dart';
import 'package:aggregator_app/data/datasources/remote/news_remote_datasource.dart';
import 'package:aggregator_app/data/models/article_model.dart';
import 'package:aggregator_app/data/repositories/news_repository_impl.dart';
import 'package:aggregator_app/domain/repositories/news_repository.dart';
import 'package:aggregator_app/features/home/bloc/news_bloc.dart';
import 'package:aggregator_app/features/search/bloc/search_bloc.dart';
import 'package:aggregator_app/features/settings/bloc/theme_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';


final sl = GetIt.instance;

Future<void> init() async {
// region Features - BLoCs
  // BLoCs are registered as 'factory' because we want a new instance
  // for different parts of the UI (e.g., one NewsBloc per category tab).
  sl.registerFactory(() => NewsBloc(repository: sl()));
  sl.registerFactory(() => SearchBloc(repository: sl()));

  // ThemeBloc is registered as 'lazySingleton' because we want one
  // instance to manage the theme for the whole app.
  sl.registerLazySingleton(() => ThemeBloc(hiveService: sl()));
// endregion

// region Domain - Repositories
  sl.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
    connectivityService: sl(),
    logger: sl(),
  ));
// endregion

// region Data - DataSources
  sl.registerLazySingleton<NewsRemoteDataSource>(
          () => NewsRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<NewsLocalDataSource>(
          () => NewsLocalDataSourceImpl(hive: sl()));
// endregion

// region Core - Services & Clients
  sl.registerLazySingleton<ConnectivityService>(
          () => ConnectivityServiceImpl(connectivity: sl()));
  sl.registerLazySingleton<HiveService>(() => HiveServiceImpl(
    settingsBox: sl(instanceName: HiveConstants.settingsBox),
    articlesBox: sl(instanceName: HiveConstants.articlesBox),
  ));

  // Register Dio client
  sl.registerLazySingleton<Dio>(() => DioClient.create(ApiConfig.apiKey));

  // Register Hive Boxes
  sl.registerLazySingleton<Box<dynamic>>(
          () => Hive.box(HiveConstants.settingsBox),
      instanceName: HiveConstants.settingsBox);
  sl.registerLazySingleton<Box<ArticleModel>>(
          () => Hive.box<ArticleModel>(HiveConstants.articlesBox),
      instanceName: HiveConstants.articlesBox);

  // External packages
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => Logger());
// endregion
}