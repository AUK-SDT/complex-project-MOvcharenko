import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/app_constants.dart';

class ApiClient {
  ApiClient._();

  static ApiClient? _instance;
  static ApiClient get instance => _instance ??= ApiClient._();

  late final Dio _dio;

  final _cacheOptions = CacheOptions(
    store: MemCacheStore(),
    maxStale: const Duration(minutes: 30),
    policy: CachePolicy.forceCache,
  );

  Dio get dio => _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.tmdbBaseUrl,
        queryParameters: {'api_key': AppConstants.tmdbApiKey},
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.addAll([
      DioCacheInterceptor(options: _cacheOptions),
      LogInterceptor(requestBody: false, responseBody: false),
      PrettyDioLogger()
    ]);
  }
}
