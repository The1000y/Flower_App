import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRepo)
class ProfileRepoImp implements ProfileRepo {
  ProfileRepoImp(this.profData);

  final ProfileLocalDataSource profData;

  @override
  Future<BaseResponce<UserEntity>> getProfile() async {
    try {
      final userData = await profData.getProfile();

      return switch (userData) {
        SuccessResponce() => SuccessResponce(userData.data.toUserEntity()),
        ErrorResponce() => ErrorResponce(userData.error),
      };
    } catch (error) {
      return ErrorResponce(
        error is Exception ? error : Exception(error.toString()),
      );
    }
  }
}
