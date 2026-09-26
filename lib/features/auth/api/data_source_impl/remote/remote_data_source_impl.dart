import 'package:dio/dio.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/api/client/auth_api_client.dart';
import 'package:flower_app/features/auth/data/data_source/remote_data_source/remote_data_source.dart';
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
import 'package:injectable/injectable.dart';

@Injectable(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final AuthApiClient _authApiClient;

  RemoteDataSourceImpl(this._authApiClient);

  @override
  Future<LoginResponse> login(LoginRequest login) async {
    try {
      return await _authApiClient.login(login);
    } catch (error) {
      return LoginResponse(
        isSuccess: false,
        errorCode: _statusCode(error),
        message: _errorMessage(error, AppStrings.invalidCredentials),
        data: null,
      );
    }
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      return await _authApiClient.register(request);
    } catch (error) {
      return RegisterResponse(
        isSuccess: false,
        errorCode: _statusCode(error),
        message: _errorMessage(error, AppStrings.registerError),
        data: false,
      );
    }
  }

  @override
  Future<BaseResponce<ForgotPasswordResponseDto>> forgotPassword(
    ForgotPasswordRequestDto request,
  ) async {
    try {
      final response = await _authApiClient.forgotPassword(request);
      if (response.isSuccess) {
        return SuccessResponce(response);
      }
      return ErrorResponce(Exception(response.message));
    } catch (error) {
      return ErrorResponce(
        error is Exception ? error : Exception(error.toString()),
      );
    }
  }

  @override
  Future<BaseResponce<VerifyOtpResponse>> verifyOtp({
    required VerifyOtpRequest verifyOtpRequest,
  }) async {
    try {
      final response = await _authApiClient.verifyOtp(verifyOtpRequest);
      if (response.isSuccess == true && response.data?.resetToken != null) {
        return SuccessResponce(response);
      }
      return ErrorResponce(
        Exception(response.message ?? 'Invalid OTP or email'),
      );
    } catch (error) {
      return ErrorResponce(
        error is Exception ? error : Exception(error.toString()),
      );
    }
  }

  @override
  Future<BaseResponce<ResetPasswordResponseDto>> resetPassword(
    ResetPasswordRequestDto request,
  ) async {
    try {
      final response = await _authApiClient.resetPassword(request);
      if (response.isSuccess) {
        return SuccessResponce(response);
      }
      return ErrorResponce(Exception(response.message));
    } catch (error) {
      return ErrorResponce(
        error is Exception ? error : Exception(error.toString()),
      );
    }
  }

  int? _statusCode(Object error) {
    if (error is DioException) {
      return error.response?.statusCode;
    }
    return 500;
  }

  String _errorMessage(Object error, String fallback) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final message = data['error'] ?? data['message'] ?? data['details'];
        if (message != null && message.toString().trim().isNotEmpty) {
          return message.toString();
        }
      }
      if (data is String && data.trim().isNotEmpty) {
        return data;
      }
    }
    return fallback;
  }
}
