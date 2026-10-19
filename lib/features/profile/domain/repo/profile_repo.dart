import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import '../entities/profile_entity.dart';

abstract interface class ProfileRepo {
  Future<BaseResponce<ChangePasswordEntity>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
  Future<BaseResponce<ProfileEntity>> getProfile();
  Future<BaseResponce<ProfileEntity>> updateProfile(ProfileEntity profile);
}
