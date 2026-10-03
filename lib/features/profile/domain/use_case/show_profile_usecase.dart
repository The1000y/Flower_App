import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShowProfileUsecase {
  final ProfileRepo _repo;

  ShowProfileUsecase(this._repo);
  Future<BaseResponce<UserEntity>> getProfile() async {
    return _repo.getProfile();
  }
}
