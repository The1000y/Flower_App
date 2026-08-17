import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/api/data_source_impl/local/local_data_source_impl.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/forgot_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/reset_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/forgot_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/reset_password_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocalDataSourceImpl localDataSource;

  setUp(() {
    localDataSource = LocalDataSourceImpl();
  });

  group('LocalDataSourceImpl - forgotPassword', () {
    test(
      'should return SuccessResponce when email is correct',
      () async {
        const request = ForgotPasswordRequestDto(
          email: 'user@example.com',
        );

        final result = await localDataSource.forgotPassword(request);

        expect(result, isA<SuccessResponce<ForgotPasswordResponseDto>>());

        final success =
            result as SuccessResponce<ForgotPasswordResponseDto>;

        expect(success.data.isSuccess, true);
        expect(success.data.data, '123456');
        expect(success.data.message, 'OTP sent successfully.');
        expect(success.data.errorCode, '0');
      },
    );

    test(
      'should return ErrorResponce when email is incorrect',
      () async {
        const request = ForgotPasswordRequestDto(
          email: 'wrong@example.com',
        );

        final result = await localDataSource.forgotPassword(request);

        expect(result, isA<ErrorResponce<ForgotPasswordResponseDto>>());

        final error =
            result as ErrorResponce<ForgotPasswordResponseDto>;

        expect(error.errorMessage, 'Email not found');
      },
    );
  });

  group('LocalDataSourceImpl - resetPassword', () {
    test(
      'should return ErrorResponce when email is incorrect',
      () async {
        const request = ResetPasswordRequestDto(
          email: 'wrong@example.com',
          resetCode: '123456',
          newPassword: 'NewPassword@123',
        );

        final result = await localDataSource.resetPassword(request);

        expect(result, isA<ErrorResponce<ResetPasswordResponseDto>>());

        final error =
            result as ErrorResponce<ResetPasswordResponseDto>;

        expect(error.errorMessage, 'Email not found');
      },
    );

    test(
      'should return ErrorResponce when OTP is incorrect',
      () async {
        const request = ResetPasswordRequestDto(
          email: 'user@example.com',
          resetCode: 'wrong-otp',
          newPassword: 'NewPassword@123',
        );

        final result = await localDataSource.resetPassword(request);

        expect(result, isA<ErrorResponce<ResetPasswordResponseDto>>());

        final error =
            result as ErrorResponce<ResetPasswordResponseDto>;

        expect(error.errorMessage, 'Invalid OTP');
      },
    );

    test(
      'should return ErrorResponce when password is empty',
      () async {
        const request = ResetPasswordRequestDto(
          email: 'user@example.com',
          resetCode: '123456',
          newPassword: '',
        );

        final result = await localDataSource.resetPassword(request);

        expect(result, isA<ErrorResponce<ResetPasswordResponseDto>>());

        final error =
            result as ErrorResponce<ResetPasswordResponseDto>;

        expect(error.errorMessage, 'Password cannot be empty');
      },
    );

    test(
      'should return SuccessResponce when all data is correct',
      () async {
        const request = ResetPasswordRequestDto(
          email: 'user@example.com',
          resetCode: '123456',
          newPassword: 'NewPassword@123',
        );

        final result = await localDataSource.resetPassword(request);

        expect(result, isA<SuccessResponce<ResetPasswordResponseDto>>());

        final success =
            result as SuccessResponce<ResetPasswordResponseDto>;

        expect(success.data.isSuccess, true);
        expect(success.data.message, 'Password reset successfully.');
        expect(success.data.errorCode, '0');
      },
    );
  });
}