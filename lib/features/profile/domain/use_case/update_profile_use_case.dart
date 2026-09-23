import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateProfileUseCase {
  final ProfileRepo profileRepo;

  UpdateProfileUseCase(this.profileRepo);

  Future<BaseResponce<ProfileEntity>> call(ProfileEntity profileUpdate) =>
      profileRepo.updateProfile(profileUpdate);
}