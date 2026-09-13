import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptors extends Interceptor {
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🚀 REQUEST');
    debugPrint('METHOD: ${options.method}');
    debugPrint('URL: ${options.uri}');
    debugPrint('HEADERS: ${options.headers}');
    debugPrint('QUERY: ${options.queryParameters}');
    debugPrint('BODY: ${options.data}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // TODO: Get token from secure storage
    // options.headers['Authorization'] = 'Bearer $token';

    handler.next(options);
  }

  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('✅ RESPONSE');
    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('URL: ${response.requestOptions.uri}');
    debugPrint('HEADERS: ${response.headers}');
    debugPrint('DATA: ${response.data}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    handler.next(response);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('❌ ERROR');
    debugPrint('TYPE: ${err.type}');
    debugPrint('STATUS: ${err.response?.statusCode}');
    debugPrint('URL: ${err.requestOptions.uri}');
    debugPrint('MESSAGE: ${err.message}');
    debugPrint('RESPONSE HEADERS: ${err.response?.headers}');
    debugPrint('RESPONSE DATA: ${err.response?.data}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // TODO: Delete token from secure storage if needed

    handler.next(err);
  }
}