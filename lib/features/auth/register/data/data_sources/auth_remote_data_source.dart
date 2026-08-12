import '../models/register_request.dart';
import '../models/register_response.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponse> register(RegisterRequest request);


}