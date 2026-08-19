import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/login_credentials.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';

abstract interface class AuthRepo {
  Future<BaseResponce<LoginEntity>> login(
    LoginCredentials credentials, {
    bool rememberMe = false,
  });

  Future<String?> getRememberedEmail();

  Future<void> saveRememberedEmail(String email);

  Future<void> deleteRememberedEmail();
}
