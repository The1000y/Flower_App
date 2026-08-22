import 'package:injectable/injectable.dart';
import '../../../../../config/errors/hadel_error_exception.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/register_params.dart';
import '../../domain/repos/auth_repo.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/register_request.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;
  AuthRepoImpl(this._authRemoteDataSource);

  @override
  Future<AuthEntity> register(RegisterParams params) async {
    try {

      final request = RegisterRequest.fromParams(params);
      
      final response = await _authRemoteDataSource.register(request);
      
      return AuthEntity(
        token: response.token, 
        message: response.message,
      );
    } catch (error) {
      throw HandelErrorException().handelErrorexception(error as Exception);
    }
  }
}
