import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/forgot_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/reset_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/verify_otp_request.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/forgot_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/reset_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/verify_otp_response.dart';
import 'package:injectable/injectable.dart';

import '../../client/auth_api_client.dart';

@Injectable(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  final AuthApi _authApi;
  LocalDataSourceImpl(this._authApi);

  @override
  Future<BaseResponce<ForgotPasswordResponseDto>> forgotPassword(
      ForgotPasswordRequestDto request,
      ) async {
    try {
      final response = await _authApi.forgotPassword(request);
      return SuccessResponce<ForgotPasswordResponseDto>(response);
    } catch (e) {
      return ErrorResponce<ForgotPasswordResponseDto>(
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  @override
  Future<BaseResponce<ResetPasswordResponseDto>> resetPassword(
      ResetPasswordRequestDto request,
      ) async {
    try {
      final response = await _authApi.resetPassword(request);
      return SuccessResponce<ResetPasswordResponseDto>(response);
    } catch (e) {
      return ErrorResponce<ResetPasswordResponseDto>(
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  @override
  Future<BaseResponce<VerifyOtpResponse>> verifyOtp({
    required VerifyOtpRequest verifyOtpRequest,
  }) async {
    try {
      final response = await _authApi.verifyOtp(verifyOtpRequest);
      return SuccessResponce<VerifyOtpResponse>(response);
    } catch (e) {
      return ErrorResponce<VerifyOtpResponse>(
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}