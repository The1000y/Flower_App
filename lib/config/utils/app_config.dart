class AppConfig {
  AppConfig._();

  static const String dummyEnv = 'dummy';
  static const String prodEnv = 'prod';

  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: dummyEnv,
  );

  /// Backend base url, set it when switching to the prod environment.
  static const String baseUrl = '';
}
