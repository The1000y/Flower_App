import '../../../domain/entities/register_entity/register_params.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveUser(RegisterParams user); 
  Future<void> clearCache();
}
