import 'package:dio/dio.dart';
import 'package:wework/common/app_constnt_keys.dart';

class BaseInterceptor extends InterceptorsWrapper {
  static const headerKeyAuthorization = "Authorization";
  static const headerValueAuthorization = AppConstantString.bearerToken;
  static const headerKeyAccept = "accept";
  static const headerValueAccept = "application/json";

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Map<String, String> headers = {};
    headers[headerKeyAccept] = "application/json";
    headers[headerKeyAuthorization] = headerValueAuthorization;
    options.headers.addAll(headers);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}
