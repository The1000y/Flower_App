import 'package:injectable/injectable.dart';
import '../../../../config/errors/hadel_error_exception.dart';
import '../../domain/entities/register_entity/auth_entity.dart';
import '../../domain/entities/register_entity/register_params.dart';
import '../../domain/repo/auth_repo.dart';
import '../data_source/remote_data_source/auth_remote_data_source.dart';
import '../data_source/local_data_source/auth_local_data_source.dart';
import '../../domain/models/register_request.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepoImpl(this._authRemoteDataSource, this._authLocalDataSource);

  @override
  Future<AuthEntity> register(RegisterParams params) async {
    try {
      final request = RegisterRequest.fromParams(params);
      
      final response = await _authRemoteDataSource.register(request);
      
      if (response.isSuccess) {
        await _authLocalDataSource.saveUser(params);
      }
      
      return AuthEntity(
        isSuccess: response.isSuccess,
        errorCode: response.errorCode,
        message: response.message,
      );
    } catch (error) {
      throw HandelErrorException().handelErrorexception(error as Exception);
    }
  }
}
