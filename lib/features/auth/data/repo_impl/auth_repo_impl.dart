import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/request_login.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final LocalDataSource loginApi;
  final SecureStorageService secureStorage;

  AuthRepoImpl(this.loginApi, this.secureStorage);

  @override
  Future<BaseResponce<LoginEntity>> login(RequestLogin req) async {
    try {
      final response = await loginApi.login(req);

      if (response.isSuccess == true && response.data != null) {
        final login = response.data!.tologinEntity();

        await secureStorage.saveAccessToken(login.accessToken);
        await secureStorage.saveRefreshToken(login.refreshToken);

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
}
