import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/api/data_source_impl/remote/remote_data_source_impl.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/auth/data/model/data_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/verify_otp_request.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/forgot_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/reset_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/verify_otp_response.dart';
import 'package:flower_app/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'local_data_source_impl_test.mocks.dart';

@GenerateMocks([LocalDataSource])
void main() {
  late MockLocalDataSource mockLocalDataSource;
  late AuthRepoImpl authRepoImpl;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    authRepoImpl = AuthRepoImpl(
      mockLocalDataSource,
      RemoteDataSourceImpl(),
      SecureStorageService(const FlutterSecureStorage()),
    );
  });

  group('AuthRepoImpl - VerifyOtp Tests', () {
    test('returns SuccessResponce when the data source succeeds', () async {
      const email = 'user@example.com';
      const otp = '123456';
      when(
        mockLocalDataSource.verifyOtp(
          verifyOtpRequest: VerifyOtpRequest(email: email, otp: otp),
        ),
      ).thenAnswer(
        (_) async => SuccessResponce(
          VerifyOtpResponse(
            errorCode: 0,
            isSuccess: true,
            message: 'Operation completed successfully.',
            data: Datadto(
              expiresAtUtc: DateTime.now(),
              resetToken: 'token123',
            ),
          ),
        ),
      );

      final result = await authRepoImpl.verifyOtp(email: email, otp: otp);

      expect(result, isA<SuccessResponce<VerifyOtpEntity>>());
      verify(
        mockLocalDataSource.verifyOtp(
          verifyOtpRequest: VerifyOtpRequest(email: email, otp: otp),
        ),
      ).called(1);
    });

    test('returns ErrorResponce when the data source fails', () async {
      const email = 'user@example.com';
      const otp = 'invalid';
      when(
        mockLocalDataSource.verifyOtp(
          verifyOtpRequest: VerifyOtpRequest(email: email, otp: otp),
        ),
      ).thenAnswer(
        (_) async => ErrorResponce<VerifyOtpResponse>(
          Exception('Invalid OTP or email'),
        ),
      );

      final result = await authRepoImpl.verifyOtp(email: email, otp: otp);

      expect(result, isA<ErrorResponce<VerifyOtpEntity>>());
    });
  });

  group('AuthRepoImpl - Password recovery tests', () {
    test('delegates a successful forgot-password request', () async {
      when(mockLocalDataSource.forgotPassword(any)).thenAnswer(
        (_) async => SuccessResponce(
          ForgotPasswordResponseDto(
            data: 'success',
            message: 'Password reset email sent',
            errorCode: '',
            isSuccess: true,
          ),
        ),
      );

      final result = await authRepoImpl.forgetPassword(email: 'test@gmail.com');

      expect(result, isA<SuccessResponce>());
      verify(mockLocalDataSource.forgotPassword(any)).called(1);
    });

    test('delegates a failed forgot-password request', () async {
      when(mockLocalDataSource.forgotPassword(any)).thenAnswer(
        (_) async => ErrorResponce(Exception('Something went wrong')),
      );

      final result = await authRepoImpl.forgetPassword(email: 'test@gmail.com');

      expect(result, isA<ErrorResponce>());
    });

    test('delegates a successful reset-password request', () async {
      when(mockLocalDataSource.resetPassword(any)).thenAnswer(
        (_) async => SuccessResponce(
          ResetPasswordResponseDto(
            data: 'success',
            message: 'Password reset successfully',
            errorCode: '',
            isSuccess: true,
          ),
        ),
      );

      final result = await authRepoImpl.resetPassword(
        email: 'test@gmail.com',
        otp: '123456',
        password: 'Password123',
      );

      expect(result, isA<SuccessResponce>());
      verify(mockLocalDataSource.resetPassword(any)).called(1);
    });

    test('delegates a failed reset-password request', () async {
      when(mockLocalDataSource.resetPassword(any)).thenAnswer(
        (_) async => ErrorResponce(Exception('Something went wrong')),
      );

      final result = await authRepoImpl.resetPassword(
        email: 'test@gmail.com',
        otp: '123456',
        password: 'Password123',
      );

      expect(result, isA<ErrorResponce>());
    });
  });
}
