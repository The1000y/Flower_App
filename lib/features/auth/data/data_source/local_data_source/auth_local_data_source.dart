
import '../../model/request/register_request/register_request.dart';
import '../../model/responce/register_responce/register_response.dart';

abstract class AuthLocalDataSource {
  // Future<void> saveToken(String token);
  // Future<String?> getToken();
  // Future<void> saveUser(RegisterParams user);
  // Future<void> clearCache();
  Future<RegisterResponse> register(RegisterRequest request);
}
