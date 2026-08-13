import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';

class ResetPasswordUserCase {
  AuthRepo authRepo;
  ResetPasswordUserCase({required this.authRepo});

  Future<BaseResponce<ResetPassswordEntity>> call({
    required String email,
    required String otp,
    required String password,
  }) async {
   BaseResponce<ResetPassswordEntity> responce = await authRepo.resetPassword(email: email, otp: otp, password: password);
    return responce;
  }
}
