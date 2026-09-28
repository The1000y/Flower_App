import 'package:dio/dio.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/constants/api_strings/api_strings.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/api/service/token_refresh_service.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptors extends Interceptor {
  /// Marks a request that has already been replayed after a token refresh, so a
  /// second `401` is surfaced instead of triggering another refresh. Without it
  /// a request the gateway keeps rejecting would loop forever.
  static const String retriedFlag = 'authRetried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    debugPrint('Interceptor executed');

    // A replayed request already carries the access token that was just
    // obtained from the refresh call. Re-reading storage here would overwrite
    // it with the stale token the gateway just rejected.
    if (options.extra[retriedFlag] == true) {
      handler.next(options);
      return;
    }

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
    final options = err.requestOptions;

    final isRejectedToken = err.response?.statusCode == 401;
    final isRefreshCall = options.path == ApiStrings.refreshToken;
    final alreadyRetried = options.extra[retriedFlag] == true;

    // A 401 is the only signal that the access token was rejected, so
    // everything else passes straight through. The refresh call itself is
    // excluded to keep a rejected refresh from recursing, and a request that
    // has already been replayed is left to fail normally.
    if (!isRejectedToken || isRefreshCall || alreadyRetried) {
      handler.next(err);
      return;
    }

    _refreshAndRetry(err, options, handler);
  }

  Future<void> _refreshAndRetry(
    DioException err,
    RequestOptions options,
    ErrorInterceptorHandler handler,
  ) async {
    final newAccessToken = await getIt<TokenRefreshService>()
        .refreshAccessToken();

    if (newAccessToken == null) {
      // The session cannot be renewed and the stored credentials have been
      // dropped, so the user has to sign in again. The original 401 is kept to
      // preserve the error the caller already handles.
      handler.next(err);
      return;
    }

    // Replaying the same options preserves the method, url, query parameters,
    // headers and body of the failed request.
    options.extra[retriedFlag] = true;
    options.headers['Authorization'] = 'Bearer $newAccessToken';

    try {
      final retried = await getIt<Dio>().fetch<dynamic>(options);
      handler.resolve(retried);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
