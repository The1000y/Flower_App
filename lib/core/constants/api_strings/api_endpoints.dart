class ApiEndpoints {
  ApiEndpoints._();

  // ---- Auth: Registration ----
  // NOTE: Postman collection uses this path, but the OpenAPI yaml spec has
  // a duplicated segment: /api/CustomerRegistration/CustomerRegistration/register
  // If this 404s, try the yaml version instead.
  static const String customerRegistration = '/api/CustomerRegistration/register';
  static const String driverRegistration = '/api/DriverRegistration/driverregister';

  // ---- Auth: Login ----
  static const String login = '/api/Login';
  static const String reactivateToken = '/api/Login/reactivate';

  // ---- Auth: Password Management ----
  static const String forgotPassword = '/api/Password/forgot-password';
  static const String verifyOtp = '/api/Password/verify-otp';
  static const String resetPassword = '/api/Password/reset-password';

  // ---- Auth: User Profile & Security ----
  static const String updateProfile = '/users/me';
  static const String changePassword = '/users/me/change-password';
  static const String changePasswordAlt = '/users/me/password';
}