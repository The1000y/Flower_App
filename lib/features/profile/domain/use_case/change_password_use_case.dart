import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordUseCase {
  final ProfileRepo profileRepo;

  ChangePasswordUseCase(this.profileRepo);

  Future<BaseResponce<ChangePasswordEntity>> call({
    required String? currentPassword,
    required String? newPassword,
    required String? confirmNewPassword,
  }) async {
    // 1. التحقق من صحة المدخلات
    if (currentPassword == null || currentPassword.trim().isEmpty) {
      return ErrorResponce<ChangePasswordEntity>(
        Exception('Current password cannot be empty'),
      );
    }

    if (newPassword == null || newPassword.trim().isEmpty) {
      return ErrorResponce<ChangePasswordEntity>(
        Exception('New password cannot be empty'),
      );
    }

    if (newPassword != confirmNewPassword) {
      return ErrorResponce<ChangePasswordEntity>(
        Exception('Passwords do not match'),
      );
    }

    // 2. إرسال البيانات للـ Repo
    return await profileRepo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmNewPassword!,
    );
  }
}
