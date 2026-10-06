import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ApiStrings {
  static String baseUrl = dotenv.env['BASE_URL'] ?? 'Api not found';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';

  static const String homeSections = '/catalog/home/sections';
  static const String categories = '/catalog/categories';
  static const String occasions = '/catalog/occasions';
  static const String occasion = '/occasion';
  static const String products = '/catalog/products';

  static const String cart = '/cart/cart';
  static const String cartItems = '/api/v1/cart/items';
  static const String cartItemsByProduct = '/cart/api/cart/items';
  static const String cartItemById = '/cart/cart/items';

  static const String areas = '/address/api/areas';
  static const String nearestStore = '/address/api/stores/nearest-store';
  static const String userAddresses = '/address/users/me/addresses';

  static const String getProfile = '/api/users/GetProfile';
  static const String updateProfile = '/api/users/UpdateProfile';
  static const String changePassword = '/users/me/change-password';

  static const String fullNameKey = 'FullName';
  static const String emailKey = 'Email';
  static const String phoneKey = 'Phone';
  static const String genderKey = 'Gender';
  static const String photoKey = 'Photo';
}