import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ApiStrings {
  static String baseUrl = dotenv.env['BASE_URL'] ?? 'Api not found';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';

  static const String homeSections = '/catalog/home/sections';
  static const String categories = '/catalog/categories';
  static const String occasions = '/catalog/occasions';
  static const String products = '/catalog/products';
}
