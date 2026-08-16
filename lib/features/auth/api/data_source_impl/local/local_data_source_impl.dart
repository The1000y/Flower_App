import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/auth/data/models/requests/forgot_password_request_dto.dart';
import 'package:flower_app/features/auth/data/models/requests/reset_password_request_dto.dart';
import 'package:flower_app/features/auth/data/models/responses/forgot_password_response_dto.dart';
import 'package:flower_app/features/auth/data/models/responses/reset_password_response_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  final Map<String, dynamic> dummyData = {
    'email': 'user@example.com',
    'password': 'Password@123',
    'otp': '123456',
  };

  @override
  Future<BaseResponce<ForgotPasswordResponseDto>> forgotPassword(
    ForgotPasswordRequestDto request,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    if (request.email != dummyData['email']) {
      return ErrorResponce<ForgotPasswordResponseDto>(
        Exception('Email not found'),
      );
    }

    return SuccessResponce<ForgotPasswordResponseDto>(
      ForgotPasswordResponseDto(
        data: dummyData['otp'],
        message: 'OTP sent successfully.',
        errorCode: '0',
        isSuccess: true,
      ),
    );
  }

  @override
  Future<BaseResponce<ResetPasswordResponseDto>> resetPassword(
    ResetPasswordRequestDto request,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    if (request.email != dummyData['email']) {
      return ErrorResponce<ResetPasswordResponseDto>(
        Exception('Email not found'),
      );
    }

    if (request.resetCode != dummyData['otp']) {
      return ErrorResponce<ResetPasswordResponseDto>(
        Exception('Invalid OTP'),
      );
    }

    if (request.newPassword.isEmpty) {
      return ErrorResponce<ResetPasswordResponseDto>(
        Exception('Password cannot be empty'),
      );
    }

    dummyData['password'] = request.newPassword;

    return SuccessResponce<ResetPasswordResponseDto>(
      ResetPasswordResponseDto(
        data: '',
        message: 'Password reset successfully.',
        errorCode: '0',
        isSuccess: true,
      ),
    );
  }
}