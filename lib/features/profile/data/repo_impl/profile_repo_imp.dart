import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRepo)
class ProfileRepoImp extends ProfileRepo {
  final ProfileLocalDataSource profData;

  ProfileRepoImp(this.profData);
  @override
  Future<BaseResponce<UserEntity>> getProfile() async {
    final userData = await profData.getProfile();

    switch (userData) {
      case SuccessResponce():
        return SuccessResponce(userData.data.toUserEntity());
      case ErrorResponce():
        return ErrorResponce(userData.error);
    }
  }
}
