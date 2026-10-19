import 'package:dio/dio.dart';
import 'package:flower_app/features/order_tracking/domain/exceptions/tracking_exception.dart';

class TrackingErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        stackTrace: err.stackTrace,
        message: err.message,
        error: _map(err),
      ),
    );
  }

  TrackingException _map(DioException err) {
    final message = _messageFromBody(err.response?.data);

    switch (err.response?.statusCode) {
      case 400:
        return TrackingInvalidRequestException(message);
      case 401:
        return TrackingUnauthorizedException(message);
      case 403:
        return TrackingForbiddenException(message);
      case 404:
        return TrackingNotFoundException(message);
      case 422:
        return TrackingNotAvailableException(message);
    }

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return TrackingNetworkException(message);
      default:
        return TrackingServerException(message);
    }
  }

  String? _messageFromBody(dynamic data) {
    if (data is Map) {
      final message = data['message']?.toString().trim();
      if (message != null && message.isNotEmpty) return message;

      final error = data['error'];
      if (error is Map) {
        final code = error['code']?.toString().trim();
        if (code != null && code.isNotEmpty) return code;
      }
    }
    return null;
  }
}
