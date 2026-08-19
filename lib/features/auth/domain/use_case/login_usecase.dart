import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/login_credentials.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final AuthRepo repo;

  LoginUseCase(this.repo);

  Future<BaseResponce<LoginEntity>> call(
    LoginCredentials credentials, {
    bool rememberMe = false,
  }) {
    return repo.login(credentials, rememberMe: rememberMe);
  }
}
