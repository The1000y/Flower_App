import 'package:flower_app/config/base/base_responce.dart';
import 'package:injectable/injectable.dart';

import '../../../data/data_source/local_data_source/local_data_source.dart';
import '../../../domain/entities/profile_entity.dart';

@LazySingleton(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImp implements ProfileLocalDataSource {
  ProfileEntity _profile = const ProfileEntity(
    firstName: 'Sara',
    lastName: 'Ahmed',
    email: 'sara.ahmed@example.com',
    phoneNumber: '+201000000000',
    gender: 'Female',
  );

  @override
  Future<BaseResponce<ProfileEntity>> getProfile() async {
    return SuccessResponce<ProfileEntity>(_profile);
  }

  @override
  Future<BaseResponce<ProfileEntity>> updateProfile(ProfileEntity profile) async {
    _profile = profile;
    return SuccessResponce<ProfileEntity>(_profile);
  }
}