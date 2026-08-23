import 'package:dio/dio.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';

class AuthInterceptors extends Interceptor {
  final SecureStorageService _secureStorage;

  AuthInterceptors(this._secureStorage);

  static const String _bearerPrefix = 'Bearer ';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = '$_bearerPrefix$token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _secureStorage.clear();
    }

    handler.next(err);
  }
}
