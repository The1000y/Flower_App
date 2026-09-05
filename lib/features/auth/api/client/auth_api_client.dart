import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/login_request.dart';
import 'package:flower_app/features/auth/data/model/response/login_response/login_response.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/data/model/responce/register_responce/register_response.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/forgot_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/forgot_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/verify_otp_request.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/verify_otp_response.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/reset_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/reset_password_response_dto.dart';

import '../../../../core/constants/api_strings/api_endpoints.dart';

part 'auth_api_client.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST(ApiEndpoints.login)
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST(ApiEndpoints.customerRegistration)
  Future<RegisterResponse> register(@Body() RegisterRequest request);

  @POST(ApiEndpoints.forgotPassword)
  Future<ForgotPasswordResponseDto> forgotPassword(@Body() ForgotPasswordRequestDto request);

  @POST(ApiEndpoints.verifyOtp)
  Future<VerifyOtpResponse> verifyOtp(@Body() VerifyOtpRequest request);

  @POST(ApiEndpoints.resetPassword)
  Future<ResetPasswordResponseDto> resetPassword(@Body() ResetPasswordRequestDto request);
}