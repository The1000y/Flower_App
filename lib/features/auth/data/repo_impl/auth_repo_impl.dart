import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/login_request.dart';
import 'package:flower_app/features/auth/domain/entities/login_credentials.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final RemoteDataSource _loginApi;
  final SecureStorageService _secureStorage;

  AuthRepoImpl(this._loginApi, this._secureStorage);

  @override
  Future<BaseResponce<LoginEntity>> login(
    LoginCredentials credentials, {
    bool rememberMe = false,
  }) async {
    try {
      final response = await _loginApi.login(
        LoginRequest(
          email: credentials.email,
          password: credentials.password,
        ),
      );

      if (response.isSuccess == true && response.data != null) {
        final login = response.data!.toLoginEntity();

        if (rememberMe) {
          await _secureStorage.saveAccessToken(login.accessToken);
          await _secureStorage.saveRefreshToken(login.refreshToken);
        }

        return SuccessResponce(login);
      }

      return ErrorResponce(
        Exception(response.message ?? AppStrings.loginFailed),
      );
    } catch (e) {
      return ErrorResponce(
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  @override
  Future<String?> getRememberedEmail() {
    return _secureStorage.getRememberedEmail();
  }

  @override
  Future<void> saveRememberedEmail(String email) {
    return _secureStorage.saveRememberedEmail(email);
  }

  @override
  Future<void> deleteRememberedEmail() {
    return _secureStorage.deleteRememberedEmail();
  }
}
