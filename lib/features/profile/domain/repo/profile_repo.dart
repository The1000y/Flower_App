import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';

abstract class ProfileRepo {
  Future<BaseResponce<UserEntity>> getProfile();

}