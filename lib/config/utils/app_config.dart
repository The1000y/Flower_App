import 'package:injectable/injectable.dart';

class AppConfig {
  AppConfig._();

  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: Environment.prod,
  );
}
