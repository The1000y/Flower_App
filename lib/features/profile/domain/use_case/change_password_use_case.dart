import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordUseCase {
  final ProfileRepo profileRepo;

  ChangePasswordUseCase(this.profileRepo);

  Future<BaseResponce<ChangePasswordEntity>> call({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {



    // 2. إرسال البيانات للـ Repo
    return await profileRepo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmNewPassword,
    );
  }
}
