import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/model/user_dto.dart';

abstract interface class ProfileLocalDataSource {
  Future<BaseResponce<UserDto>> getProfile();
}
