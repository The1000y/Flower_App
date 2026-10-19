import 'package:dio/dio.dart';
import 'package:flower_app/l10n/l10n.dart';

class HandelErrorException {
  String handelErrorexception(Exception error) {
    if (error is DioException) return _hadelDioException(error);
    return L10n.instance.somethingWentWrongTryAgain;
  }

  String _hadelDioException(DioException error) {
    final bodyMessage = _messageFromBody(error.response?.data);
    if (bodyMessage != null && bodyMessage.isNotEmpty) {
      return bodyMessage;
    }

    switch (error.type) {
      case DioExceptionType.badCertificate:
        return 'badCertificate';
      case DioExceptionType.badResponse:
        return 'badResponse';
      case DioExceptionType.cancel:
        return 'cancel';
      case DioExceptionType.connectionTimeout:
        return 'connectionTimeout';
      case DioExceptionType.connectionError:
        return 'connectionError';
      case DioExceptionType.unknown:
        return 'unknown';
      case DioExceptionType.receiveTimeout:
        return 'receiveTimeout';
      case DioExceptionType.sendTimeout:
        return 'sendTimeout';
      case DioExceptionType.transformTimeout:
        return 'transformTimeout';
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
      } else if (error != null && error.toString().trim().isNotEmpty) {
        return error.toString();
      }

      final details = data['details']?.toString().trim();
      if (details != null && details.isNotEmpty) return details;
    }
    if (data is String && data.trim().isNotEmpty) return data;
    return null;
  }
}
