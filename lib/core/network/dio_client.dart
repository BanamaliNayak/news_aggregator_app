import 'package:aggregator_app/core/config/api_config.dart';
import 'package:dio/dio.dart';

class DioClient {
// region helpers
  static Dio create(String apiKey) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        queryParameters: {
          'apiKey': apiKey,
        },
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Optional: Add logging interceptor for debugging
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    return dio;
  }
// endregion
}