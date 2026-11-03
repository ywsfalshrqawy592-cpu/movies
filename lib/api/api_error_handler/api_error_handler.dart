import 'package:dio/dio.dart';

class ApiErrorHandler {
  static Exception handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception(
          'Connection timeout. Please try again.',
        );

      case DioExceptionType.sendTimeout:
        return Exception(
          'Request timeout. Please try again.',
        );

      case DioExceptionType.receiveTimeout:
        return Exception(
          'Server response timeout. Please try again.',
        );

      case DioExceptionType.connectionError:
        return Exception(
          'No internet connection. Please check your connection.',
        );

      case DioExceptionType.badCertificate:
        return Exception(
          'Invalid server certificate.',
        );

      case DioExceptionType.cancel:
        return Exception(
          'Request was cancelled.',
        );

      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 400:
            return Exception('Bad request.');

          case 401:
            return Exception('Unauthorized request.');

          case 403:
            return Exception('Access forbidden.');

          case 404:
            return Exception('Resource not found.');

          case 429:
            return Exception(
              'Too many requests. Please try again later.',
            );

          case 500:
            return Exception('Internal server error.');

          case 502:
            return Exception('Bad gateway.');

          case 503:
            return Exception('Service unavailable.');

          case 504:
            return Exception('Gateway timeout.');

          default:
            return Exception(
              'Server error. Please try again.',
            );
        }

      case DioExceptionType.unknown:
        return Exception(
          'An unexpected error occurred. Please try again.',
        );

      case DioExceptionType.transformTimeout:
        return Exception(
          'Data processing timeout. Please try again.',
        );
    }
  }
}