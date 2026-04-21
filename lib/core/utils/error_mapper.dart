import 'package:dio/dio.dart';
import 'failures.dart';

Failure mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
      final code = e.response?.statusCode;
      if (code == 404) return const NotFoundFailure();
      return ServerFailure('Server responded with $code.', code);
    default:
      return const UnknownFailure();
  }
}
