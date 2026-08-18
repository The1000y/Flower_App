import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/auth/data/model/data_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/verify_otp_request.dart';

import 'package:flower_app/features/auth/data/model/responce/forget_responce/verify_otp_response.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/forgot_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/reset_password_response_dto.dart';
import 'package:flower_app/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../api/data_source_impl/local/local_data_source_impl_test.mocks.dart';


@GenerateMocks([LocalDataSource])
void main() {
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
  });

  provideDummy<VerifyOtpRequest>(
    VerifyOtpRequest(email: '', otp: ''),
  );

  provideDummy<BaseResponce<VerifyOtpResponse>>(
    SuccessResponce<VerifyOtpResponse>(
      VerifyOtpResponse(
        errorCode: 0,
        isSuccess: true,
        message: "Operation completed successfully.",
        data: Datadto(expiresAtUtc: DateTime.now(), resetToken: 'token123'),
      ),
    ),
  );

  group('AuthRepoImpl - VerifyOtp Tests', () {
    test('verifyOtp should return SuccessResponce when data source succeeds',
        () async {
      // Arrange
      const email = 'user@example.com';
      const otp = '123456';

      when(
        mockLocalDataSource.verifyOtp(
          verifyOtpRequest: VerifyOtpRequest(email: email, otp: otp),
        ),
      ).thenAnswer(
        (_) async => SuccessResponce<VerifyOtpResponse>(
          VerifyOtpResponse(
            errorCode: 0,
            isSuccess: true,
            message: "Operation completed successfully.",
            data: Datadto(expiresAtUtc: DateTime.now(), resetToken: 'token123'),
          ),
        ),
      );

      final authRepoImpl = AuthRepoImpl(mockLocalDataSource);

      // Act
      final result = await authRepoImpl.verifyOtp(email: email, otp: otp);

      // Assert
      expect(result, isA<SuccessResponce<VerifyOtpEntity>>());
    });

    test('verifyOtp should return ErrorResponce when data source fails',
        () async {
      // Arrange
      const email = 'user@example.com';
      const otp = 'invalid';

      when(
        mockLocalDataSource.verifyOtp(
          verifyOtpRequest: VerifyOtpRequest(email: email, otp: otp),
        ),
      ).thenAnswer(
        (_) async => ErrorResponce<VerifyOtpResponse>(
          Exception("Invalid OTP or email"),
        ),
      );

      final authRepoImpl = AuthRepoImpl(mockLocalDataSource);

      // Act
      final result = await authRepoImpl.verifyOtp(email: email, otp: otp);

      // Assert
      expect(result, isA<ErrorResponce<VerifyOtpEntity>>());
    });
  });

  group('AuthRepoImpl - ForgotPassword Tests', () {
    test('should return SuccessResponce when localDataSource succeeds', () async {
      final responseDto = ForgotPasswordResponseDto(
        data: 'success',
        message: 'Password reset email sent',
        errorCode: '',
        isSuccess: true,
      );

      when(mockLocalDataSource.forgotPassword(
        any,
      )).thenAnswer(
        (_) async => SuccessResponce<ForgotPasswordResponseDto>(responseDto),
      );

      final authRepoImpl = AuthRepoImpl(mockLocalDataSource);

      final result = await authRepoImpl.forgetPassword(
        email: 'test@gmail.com',
      );

      expect(result, isA<SuccessResponce>());
      verify(mockLocalDataSource.forgotPassword(any)).called(1);
    });

    test('should return ErrorResponce when localDataSource fails', () async {
      final exception = Exception('Something went wrong');

      when(mockLocalDataSource.forgotPassword(any)).thenAnswer(
        (_) async => ErrorResponce(exception),
      );

      final authRepoImpl = AuthRepoImpl(mockLocalDataSource);

      final result = await authRepoImpl.forgetPassword(
        email: 'test@gmail.com',
      );

      expect(result, isA<ErrorResponce>());
      verify(mockLocalDataSource.forgotPassword(any)).called(1);
    });
  });

  group('AuthRepoImpl - ResetPassword Tests', () {
    test('should return SuccessResponce when localDataSource succeeds', () async {
      final responseDto = ResetPasswordResponseDto(
        data: 'success',
        message: 'Password reset successfully',
        errorCode: '',
        isSuccess: true,
      );

      when(mockLocalDataSource.resetPassword(any)).thenAnswer(
        (_) async => SuccessResponce(responseDto),
      );

      final authRepoImpl = AuthRepoImpl(mockLocalDataSource);

      final result = await authRepoImpl.resetPassword(
        email: 'test@gmail.com',
        otp: '123456',
        password: 'Password123',
      );

      expect(result, isA<SuccessResponce>());
      verify(mockLocalDataSource.resetPassword(any)).called(1);
    });

    test('should return ErrorResponce when localDataSource fails', () async {
      final exception = Exception('Something went wrong');

      when(mockLocalDataSource.resetPassword(any)).thenAnswer(
        (_) async => ErrorResponce(exception),
      );

      final authRepoImpl = AuthRepoImpl(mockLocalDataSource);

      final result = await authRepoImpl.resetPassword(
        email: 'test@gmail.com',
        otp: '123456',
        password: 'Password123',
      );

      expect(result, isA<ErrorResponce>());
      verify(mockLocalDataSource.resetPassword(any)).called(1);
    });
  });
}