import 'package:flower_app/features/auth/register/data/api/auth_api_client.dart';
import 'package:flower_app/features/auth/register/data/data_sources/auth_remote_data_source.dart';
import 'package:injectable/injectable.dart';
import 'package:flower_app/config/errors/hadel_error_exception.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';


@Injectable(as: AuthRemoteDataSource)

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient _authApiClient;
  AuthRemoteDataSourceImpl(this._authApiClient);

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
   try {
     return _authApiClient.register(request);
   }
   catch(error){
     throw HandelErrorException().handelErrorexception(error as Exception);
   }

  }
  }




