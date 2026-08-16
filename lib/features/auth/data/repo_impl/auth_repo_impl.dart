import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/errors/hadel_error_exception.dart';
import '../../domain/entities/register_entity/register_entity.dart';

import '../../domain/repo/auth_repo.dart';
import '../data_source/remote_data_source/auth_remote_data_source.dart';
import '../data_source/local_data_source/auth_local_data_source.dart';

import '../model/request/register_request/register_request.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
 // final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepoImpl( this._authLocalDataSource);

  @override
  Future<BaseResponce<RegisterEntity>> register(RegisterRequest request) async {
    try {
     // final request = RegisterRequest.fromParams(params);
      
      final response = await _authLocalDataSource.register(request);
      
      if (response.isSuccess==true) {
        return SuccessResponce(response.toregisterentity());

      }
      
      return ErrorResponce(
         Exception(response.message??AppStrings.registererror,  )

      );
    } catch (error) {
      return ErrorResponce(error is Exception?error:Exception(error.toString()));

    }
  }
}
