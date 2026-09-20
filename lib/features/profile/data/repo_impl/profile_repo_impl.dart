import 'package:injectable/injectable.dart';

import '../../../../config/base/base_responce.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repo/profile_repo.dart';
import '../data_source/local_data_source/local_data_source.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileLocalDataSource _localDataSource;

  ProfileRepoImpl(this._localDataSource);

  @override
  Future<BaseResponce<ProfileEntity>> getProfile() => _localDataSource.getProfile();

  @override
  Future<BaseResponce<ProfileEntity>> updateProfile(ProfileEntity profile) =>
      _localDataSource.updateProfile(profile);
}