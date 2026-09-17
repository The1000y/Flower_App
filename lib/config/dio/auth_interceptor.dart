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

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      debugPrint('AuthInterceptors: failed to attach token: $e');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
