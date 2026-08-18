import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/forgot_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/reset_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/forgot_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/reset_password_response_dto.dart';

abstract class RemoteDataSource {
  Future<BaseResponce<ForgotPasswordResponseDto>> ForgotPassword(
    ForgotPasswordRequestDto request,
  );
  Future<BaseResponce<ResetPasswordResponseDto>> ResetPassword(
    ResetPasswordRequestDto request,
  );
}
