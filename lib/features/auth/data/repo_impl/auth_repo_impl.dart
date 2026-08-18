import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthLocalDataSource _authLocalDataSource;
  final SecureStorageService _secureStorage;

  AuthRepoImpl(this._authLocalDataSource, this._secureStorage);

  @override
  Future<BaseResponce<RegisterEntity>> register(RegisterRequest request) async {
    try {
      // final request = RegisterRequest.fromParams(params);

      final response = await _authLocalDataSource.register(request);

      if (response.isSuccess == true) {
        return SuccessResponce(response.toregisterentity());
      }

      return ErrorResponce(
        Exception(response.message ?? AppStrings.registererror),
      );
    } catch (error) {
      return ErrorResponce(
        error is Exception ? error : Exception(error.toString()),
      );
    }
  }
}
