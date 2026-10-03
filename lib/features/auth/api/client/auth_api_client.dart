import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_strings/api_strings.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/forgot_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/reset_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/verify_otp_request.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/login_request.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/data/model/response/login_response/login_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../data/model/response/forget_response/forgot_password_response_dto.dart';
import '../../data/model/response/forget_response/reset_password_response_dto.dart';
import '../../data/model/response/forget_response/verify_otp_response.dart';
import '../../data/model/response/register_response/register_response.dart';

part 'auth_api_client.g.dart';

@singleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(ApiStrings.login)
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST(ApiStrings.register)
  Future<RegisterResponse> register(@Body() RegisterRequest request);

  @POST(ApiStrings.forgotPassword)
  Future<ForgotPasswordResponseDto> forgotPassword(
      @Body() ForgotPasswordRequestDto request,
      );

  @POST(ApiStrings.verifyOtp)
  Future<VerifyOtpResponse> verifyOtp(@Body() VerifyOtpRequest request);

  @POST(ApiStrings.resetPassword)
  Future<ResetPasswordResponseDto> resetPassword(
      @Body() ResetPasswordRequestDto request,
      );
}