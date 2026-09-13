import '../../../../config/base/base_responce.dart';
import '../entities/profile_entity.dart';

abstract interface class ProfileRepo {
  Future<BaseResponce<ProfileEntity>> getProfile();
  Future <BaseResponce<ProfileEntity>> updateProfile(ProfileEntity profile);
}