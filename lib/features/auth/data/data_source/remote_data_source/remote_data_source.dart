import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/forgot_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/reset_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/verify_otp_request.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/login_request.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/forgot_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/reset_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/verify_otp_response.dart';
import 'package:flower_app/features/auth/data/model/responce/register_responce/register_response.dart';
import 'package:flower_app/features/auth/data/model/response/login_response/login_response.dart';

abstract interface class RemoteDataSource {
  Future<LoginResponse> login(LoginRequest login);
  Future<RegisterResponse> register(RegisterRequest request);
  Future<BaseResponce<ForgotPasswordResponseDto>> forgotPassword(
    ForgotPasswordRequestDto request,
  );
  Future<BaseResponce<VerifyOtpResponse>> verifyOtp({
    required VerifyOtpRequest verifyOtpRequest,
  });
  Future<BaseResponce<ResetPasswordResponseDto>> resetPassword(
    ResetPasswordRequestDto request,
  );
}