import 'package:dio/dio.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptors extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    debugPrint('Interceptor executed');
    try {
      final token = await getIt<SecureStorageService>().getAccessToken();
      debugPrint('TOKEN--------->: $token');
      debugPrint('TOKEN IS EMPTY------->: ${token?.isEmpty}');
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🚀 REQUEST');
      debugPrint('METHOD: ${options.method}');
      debugPrint('URL: ${options.uri}');
      debugPrint('HEADERS: ${options.headers}');
      debugPrint('QUERY: ${options.queryParameters}');
      debugPrint('BODY: ${options.data}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    } catch (e) {
      debugPrint('AuthInterceptors: failed to attach token: $e');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('❌ ERROR');
    debugPrint('TYPE: ${err.type}');
    debugPrint('STATUS: ${err.response?.statusCode}');
    debugPrint('URL: ${err.requestOptions.uri}');
    debugPrint('MESSAGE: ${err.message}');
    debugPrint('RESPONSE HEADERS: ${err.response?.headers}');
    debugPrint('RESPONSE DATA: ${err.response?.data}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // TODO: Refresh token handling / clear token on 401 if needed

    handler.next(err);
  }
}
