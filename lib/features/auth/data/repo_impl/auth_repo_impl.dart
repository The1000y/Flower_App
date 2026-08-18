import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/forgot_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/reset_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/verify_otp_request.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/forgot_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/reset_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/verify_otp_response.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';

import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  LocalDataSource localDataSource;
  AuthRepoImpl(this.localDataSource);
   @override
  Future<BaseResponce<ForgetPasswordEntity>> forgetPassword({
    required String email,
  }) async {
    final forgetdto = ForgotPasswordRequestDto(email: email);
    final BaseResponce<ForgotPasswordResponseDto> responce =
        await localDataSource.forgotPassword(forgetdto);
    switch (responce) {
      case SuccessResponce<ForgotPasswordResponseDto>():
        return SuccessResponce(responce.data.toDomain());

      case ErrorResponce<ForgotPasswordResponseDto>():
        return ErrorResponce(responce.error);
    }
  }

  @override
  Future<BaseResponce<ResetPassswordEntity>> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    final resetpassdto = ResetPasswordRequestDto(
      email: email,
      newPassword: password,
      resetCode: otp,
    );
    final BaseResponce<ResetPasswordResponseDto> responce =
        await localDataSource.resetPassword(resetpassdto);
    switch (responce) {
      case SuccessResponce<ResetPasswordResponseDto>():
        return SuccessResponce(responce.data.toDomain());
        case ErrorResponce<ResetPasswordResponseDto>():
        return ErrorResponce(responce.error);
    }
  }

  @override
  Future<BaseResponce<VerifyOtpEntity>> verifyOtp({
    required String email,
    required String otp,
  }) async {
  BaseResponce<VerifyOtpResponse> responce =  await localDataSource.verifyOtp(
      verifyOtpRequest: VerifyOtpRequest(email: email, otp: otp),
    );
    switch (responce) {
      
      case SuccessResponce<VerifyOtpResponse>():
        return SuccessResponce<VerifyOtpEntity>(
          responce.data.data!.toEntity(),
        );
      case ErrorResponce<VerifyOtpResponse>():
        return ErrorResponce<VerifyOtpEntity>(
          responce.error,
        );
    }
  }
}



