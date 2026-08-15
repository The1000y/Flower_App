import '../entities/register_entity/auth_entity.dart';
import '../entities/register_entity/register_params.dart';

abstract class AuthRepo {
  Future<AuthEntity> register(RegisterParams params);
}
