import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';

class VerifyOtpUserCase {
  AuthRepo authRepo;

  VerifyOtpUserCase(this.authRepo);
  Future<BaseResponce<VerifyOtpEntity>> call({
    required String email,
    required String otp,
  }) async {
    BaseResponce<VerifyOtpEntity> responce = await authRepo.verifyOtp(
      email: email,
      otp: otp,
    );
    return responce;
  }
}
