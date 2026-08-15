import 'package:flower_app/features/auth/api/client/auth_api_client.dart';
import 'package:flower_app/features/auth/data/data_source/remote_data_source/auth_remote_data_source.dart';
import 'package:injectable/injectable.dart';
import 'package:flower_app/config/errors/hadel_error_exception.dart';
import '../../../domain/models/register_request.dart';
import '../../../domain/models/register_response.dart';


@Injectable(as: AuthRemoteDataSource)

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient _authApiClient;
  AuthRemoteDataSourceImpl(this._authApiClient);

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
   try {
     return await _authApiClient.register(request);
   }
   catch(error){
     throw HandelErrorException().handelErrorexception(error as Exception);
   }

  }
  }




