class AppConfig {
  AppConfig._();

  static const String dummyEnv = 'dummy';

  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: dummyEnv,
  );
}
