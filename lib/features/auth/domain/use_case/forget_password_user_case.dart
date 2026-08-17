import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ForgetPasswordUserCase {
  AuthRepo authRepo;

  ForgetPasswordUserCase(this.authRepo);

  Future<BaseResponce<ForgetPasswordEntity>> call({
    required String email,
  }) async {
    BaseResponce<ForgetPasswordEntity> responce = await authRepo.forgetPassword(
      email: email,
    );
    return responce;
  }
}