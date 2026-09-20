import 'package:flower_app/config/base/base_responce.dart';
import '../../../domain/entities/profile_entity.dart';

abstract interface class ProfileLocalDataSource {
  Future<BaseResponce<ProfileEntity>> getProfile();
  Future<BaseResponce<ProfileEntity>> updateProfile(ProfileEntity profile);
}