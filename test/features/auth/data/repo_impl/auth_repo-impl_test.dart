import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:flower_app/features/auth/data/model/data_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/verify_otp_response.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/forgot_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/reset_password_response_dto.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:flower_app/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repo-impl_test.mocks.dart';

@GenerateMocks([RemoteDataSource, LocalDataSource])
void main() {
  provideDummy<BaseResponce<VerifyOtpResponse>>(
    SuccessResponce(VerifyOtpResponse(
      isSuccess: true,
      errorCode: 0,
      message: 'dummy',
      data: Datadto(resetToken: 'dummy', expiresAtUtc: DateTime.now()),
    )),
  );
  provideDummy<BaseResponce<ForgotPasswordResponseDto>>(
    SuccessResponce(ForgotPasswordResponseDto(
      isSuccess: true,
      errorCode: '',
      message: 'dummy',
      data: 'dummy',
    )),
  );
  provideDummy<BaseResponce<ResetPasswordResponseDto>>(
    SuccessResponce(ResetPasswordResponseDto(
      isSuccess: true,
      errorCode: '',
      message: 'dummy',
      data: 'dummy',
    )),
  );
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late AuthRepoImpl authRepoImpl;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    authRepoImpl = AuthRepoImpl(
      mockLocalDataSource,
      mockRemoteDataSource,
      SecureStorageService(const FlutterSecureStorage()),
    );
  });

  group('AuthRepoImpl - VerifyOtp Tests', () {
    test('verifyOtp should return SuccessResponce when data source succeeds', () async {
      const email = 'user@example.com';
      const otp = '123456';

      when(mockRemoteDataSource.verifyOtp(verifyOtpRequest: anyNamed('verifyOtpRequest')))
          .thenAnswer((_) async => SuccessResponce<VerifyOtpResponse>(
                VerifyOtpResponse(
                  errorCode: 0,
                  isSuccess: true,
                  message: 'Operation completed successfully.',
                  data: Datadto(expiresAtUtc: DateTime.now(), resetToken: 'token123'),
                ),
              ));

      final result = await authRepoImpl.verifyOtp(email: email, otp: otp);

      expect(result, isA<SuccessResponce<VerifyOtpEntity>>());
    });

    test('verifyOtp should return ErrorResponce when data source fails', () async {
      const email = 'user@example.com';
      const otp = 'invalid';

      when(mockRemoteDataSource.verifyOtp(verifyOtpRequest: anyNamed('verifyOtpRequest')))
          .thenAnswer((_) async => ErrorResponce<VerifyOtpResponse>(Exception('Invalid OTP or email')));

      final result = await authRepoImpl.verifyOtp(email: email, otp: otp);

      expect(result, isA<ErrorResponce<VerifyOtpEntity>>());
    });
  });

  group('AuthRepoImpl - ForgotPassword Tests', () {
    test('should return SuccessResponce when remoteDataSource succeeds', () async {
      final responseDto = ForgotPasswordResponseDto(
        data: 'success',
        message: 'Password reset email sent',
        errorCode: '',
        isSuccess: true,
      );

      when(mockRemoteDataSource.forgotPassword(any))
          .thenAnswer((_) async => SuccessResponce<ForgotPasswordResponseDto>(responseDto));

      final result = await authRepoImpl.forgetPassword(email: 'test@gmail.com');

      expect(result, isA<SuccessResponce>());
    });

    test('should return ErrorResponce when remoteDataSource fails', () async {
      when(mockRemoteDataSource.forgotPassword(any))
          .thenAnswer((_) async => ErrorResponce(Exception('Something went wrong')));

      final result = await authRepoImpl.forgetPassword(email: 'test@gmail.com');

      expect(result, isA<ErrorResponce>());
    });
  });

  group('AuthRepoImpl - ResetPassword Tests', () {
    test('should return SuccessResponce when remoteDataSource succeeds', () async {
      final responseDto = ResetPasswordResponseDto(
        data: 'success',
        message: 'Password reset successfully',
        errorCode: '',
        isSuccess: true,
      );

      when(mockRemoteDataSource.resetPassword(any))
          .thenAnswer((_) async => SuccessResponce(responseDto));

      final result = await authRepoImpl.resetPassword(
        email: 'test@gmail.com',
        otp: '123456',
        password: 'Password123',
      );

      expect(result, isA<SuccessResponce>());
    });

    test('should return ErrorResponce when remoteDataSource fails', () async {
      when(mockRemoteDataSource.resetPassword(any))
          .thenAnswer((_) async => ErrorResponce(Exception('Something went wrong')));

      final result = await authRepoImpl.resetPassword(
        email: 'test@gmail.com',
        otp: '123456',
        password: 'Password123',
      );

      expect(result, isA<ErrorResponce>());
    });
  });
}
