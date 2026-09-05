import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Central place for API-level constants (base URL, timeouts).
/// Endpoint paths live separately in api_endpoints.dart.
class ApiConstants {
  ApiConstants._();

  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}