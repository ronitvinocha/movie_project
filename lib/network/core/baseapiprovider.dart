import 'dart:core';
import 'package:dio/dio.dart';
import 'package:wework/network/interceptor/interceptor.dart';

const _defaultConnectTimeout = 15000;
const _defaultReceiveTimeout = 15000;

class BaseApiProvider {
  int retryCount = 0;
  int maxRetry = 3;
  late Dio _dio;
  static const String errorTag = "ApiErrorTag=";
  static const _baseUrl = 'https://api.themoviedb.org/3/movie';

  BaseApiProvider() {
    _dio = Dio();
    _dio.options = BaseOptions(
        receiveTimeout:
            const Duration(days: 0, milliseconds: _defaultReceiveTimeout),
        connectTimeout:
            const Duration(days: 0, milliseconds: _defaultConnectTimeout));
    _dio.interceptors.add(BaseInterceptor());
  }

  Dio getDio() {
    return _dio;
  }

  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    required T Function(Map<String, dynamic> response) converter,
  }) async {
    try {
      final Response response = await _dio.get(
        _baseUrl + path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResult.fromJsonToSuccessModel(converter(response.data), null);
    } catch (error) {
      if (error is DioException && handleAPIError(error)) {
        retryCount++;
        return get(path,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
            converter: converter);
      }
      return ApiResult(null, error);
    }
  }

  bool handleAPIError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return retryCount < maxRetry;
    } else {
      return false;
    }
  }
}

class ApiResult<T> {
  T? body;
  Response? response;
  dynamic error;
  ApiResult(this.response, this.error);

  factory ApiResult.fromJsonToSuccessModel(T? data, Response? response) {
    return ApiResult._parseJsonToResponse(
        body: data, response: response, error: null);
  }

  factory ApiResult.fromJsonToFailureModel(T? data, Response? response) {
    return ApiResult._parseJsonToResponse(
        body: data, response: response, error: null);
  }

  ApiResult._parseJsonToResponse({this.body, this.response, this.error});
}
