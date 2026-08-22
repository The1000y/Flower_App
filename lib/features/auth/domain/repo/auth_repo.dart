import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:flower_app/features/auth/domain/entities/login_credentials.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_entity.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_request_entity.dart';

abstract interface class AuthRepo {
  Future<BaseResponce<ForgetPasswordEntity>> forgetPassword({required String email});
  Future<BaseResponce<VerifyOtpEntity>> verifyOtp({required String email, required String otp});
  Future<BaseResponce<ResetPassswordEntity>> resetPassword({required String email, required String otp, required String password});

  Future<BaseResponce<LoginEntity>> login(LoginCredentials credentials, {bool rememberMe = false});
  Future<String?> getRememberedEmail();
  Future<void> saveRememberedEmail(String email);
  Future<void> deleteRememberedEmail();

  Future<BaseResponce<RegisterEntity>> register(RegisterRequestEntity request);
}