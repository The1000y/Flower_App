import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/auth/data/model/data_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/verify_otp_request.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/verify_otp_response.dart';
import 'package:flower_app/features/auth/data/repo_impl/auth_repo-impl.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repo-impl_test.mocks.dart';

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

  group('AuthRepoImpl Tests', () {
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
}