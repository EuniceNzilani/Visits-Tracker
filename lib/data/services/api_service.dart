import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import '../../core/config/api_config.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        headers: ApiConfig.headers,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
      ),
    );

    // Add interceptors for logging, retry, and error handling
    _dio.interceptors.addAll([
      _createLoggingInterceptor(),
      _createRetryInterceptor(),
    ]);
  }

  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        developer.log(
          'REQUEST[${options.method}] => PATH: ${options.path}',
          name: 'ApiService',
        );
        return handler.next(options);
      },
      onResponse: (response, handler) {
        developer.log(
          'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          name: 'ApiService',
        );
        return handler.next(response);
      },
      onError: (error, handler) {
        developer.log(
          'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          name: 'ApiService',
          level: 1000, // Error level
        );
        return handler.next(error);
      },
    );
  }

  Interceptor _createRetryInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (_shouldRetry(error)) {
          int retryCount = 0;
          while (retryCount < ApiConfig.maxRetries) {
            try {
              await Future.delayed(
                const Duration(milliseconds: ApiConfig.retryDelay),
              );
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              retryCount++;
              if (retryCount >= ApiConfig.maxRetries) {
                return handler.next(error);
              }
            }
          }
        }
        return handler.next(error);
      },
    );
  }

  bool _shouldRetry(DioError error) {
    return error.type == DioErrorType.connectTimeout ||
        error.type == DioErrorType.receiveTimeout ||
        error.type == DioErrorType.sendTimeout ||
        (error.response?.statusCode ?? 0) >= 500;
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioError e) {
    switch (e.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        return const TimeoutException();
      case DioErrorType.response:
        return ApiException(e.response?.statusCode ?? 500, e.response?.data);
      case DioErrorType.cancel:
        return const RequestCancelledException();
      default:
        return const NetworkException();
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final dynamic data;

  const ApiException(this.statusCode, this.data);

  @override
  String toString() {
    String message = '';
    if (statusCode >= 500) {
      message = ApiConfig.serverError;
    } else if (statusCode == 401) {
      message = ApiConfig.unauthorizedError;
    } else {
      message = data?.toString() ?? 'Unknown error occurred';
    }
    return 'ApiException: [$statusCode] $message';
  }
}

class TimeoutException implements Exception {
  const TimeoutException();

  @override
  String toString() => ApiConfig.timeoutError;
}

class NetworkException implements Exception {
  const NetworkException();

  @override
  String toString() => ApiConfig.networkError;
}

class RequestCancelledException implements Exception {
  const RequestCancelledException();

  @override
  String toString() => 'Request was cancelled';
}
