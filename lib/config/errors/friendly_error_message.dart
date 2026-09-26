import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';

/// Converts a raw failure (Dio error, backend message, or thrown exception)
/// into a safe, user-friendly message.
class FriendlyErrorMessage {
  FriendlyErrorMessage._();

  /// Returns a user-friendly message for the given failure.
  ///
  /// A non-empty backend message that is safe and understandable is kept;
  /// technical, empty, or network/status failures are mapped to a friendly
  /// message instead.
  static String from(Object? error) {
    final raw = _extractMessage(error);
    if (raw.isEmpty) return AppStrings.addressAddFailedServer;
    return _classify(raw);
  }

  static String _extractMessage(Object? error) {
    if (error == null) return '';
    if (error is String) return error.trim();
    if (error is DioException) {
      final bodyMessage = _backendMessage(error.response?.data);
      if (bodyMessage.isNotEmpty) return bodyMessage;
      return '';
    }

    final text = error.toString().trim();
    const prefix = 'Exception: ';
    final index = text.indexOf(prefix);
    return index >= 0 ? text.substring(index + prefix.length).trim() : text;
  }

  static String _backendMessage(dynamic data) {
    if (data is Map) {
      for (final key in const ['error', 'message', 'details']) {
        final value = data[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }
    }
    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }
    return '';
  }

  static String _classify(String message) {
    final normalized = message.toLowerCase();

    if (_isTechnical(normalized)) {
      return AppStrings.addressAddFailedServer;
    }

    if (_containsAny(normalized, const [
      'not serviceable',
      'not_serviceable',
      'not servable',
      'not available for delivery',
      'cannot be delivered',
      'unable to deliver',
      'not deliver in',
      'delivery unavailable',
      'service area',
      'delivery area',
      'delivery zone',
      'outside our service',
      'outside delivery',
      'out of coverage',
      'no coverage',
      'no service',
    ])) {
      return AppStrings.addressAddFailedNotServiceable;
    }

    if (_containsAny(normalized, const [
      'invalid',
      'required',
      'validation',
      'not found',
      'does not exist',
      'missing',
      'incorrect',
      'cannot',
      'must not',
      'must be',
    ])) {
      return AppStrings.addressAddFailedInvalid;
    }

    if (_containsAny(normalized, const ['something went wrong'])) {
      return AppStrings.addressAddFailedServer;
    }

    return message;
  }

  static bool _isTechnical(String normalized) {
    if (_containsAny(normalized, const [
      'connectiontimeout',
      'sendtimeout',
      'receivetimeout',
      'transformtimeout',
      'sockettimeout',
      'connectionerror',
      'badresponse',
      'badcertificate',
      'cancel',
      'dioexception',
      'dioerror',
      'stack trace',
      'package:',
      'instance of',
      "type '",
      'null check operator',
      'was null',
    ])) {
      return true;
    }
    return RegExp(r'\b[45]\d{2}\b').hasMatch(normalized);
  }

  static bool _containsAny(String text, List<String> keywords) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) return true;
    }
    return false;
  }
}