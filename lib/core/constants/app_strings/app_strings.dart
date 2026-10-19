/// Non-localizable constants: storage keys, API parameter names and API enum
/// values. All user-facing text lives in the ARB files (`lib/l10n`).
abstract class AppStrings {
  // Secure storage keys.
  static const String refreshToken = 'refresh_token';
  static const String accessToken = 'access_token';
  static const String rememberedEmail = 'remembered_email';

  // API query/path parameter names.
  static const String lat = 'lat';
  static const String lng = 'lng';
  static const String addressId = 'addressId';
  static const String orderId = 'orderId';

  // API enum values.
  static const String genderFemaleApi = 'Female';
  static const String genderMaleApi = 'Male';

  // Non-localizable display constants.
  static const String currencyUsd = '\$';
  static const String passwordMask = '••••••';
}
