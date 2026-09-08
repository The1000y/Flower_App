import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordUseCase {
  final ProfileRepo profileRepo;

  ChangePasswordUseCase(this.profileRepo);

  Future<BaseResponce<bool>> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await profileRepo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
