import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:flower_app/features/auth/domain/use_case/verify_otp_user_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'verify_otp_user_case_test.mocks.dart';

@GenerateMocks([AuthRepo])
void main() {
  provideDummy<BaseResponce<VerifyOtpEntity>>(
    SuccessResponce(
      VerifyOtpEntity(expiresAtUtc: DateTime.now(), resetToken: ''),
    ),
  );

  late MockAuthRepo mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
  });

  group('VerifyOtpUserCase Tests', () {
    test('should return SuccessResponce when verify OTP succeeds', () async {
      // Arrange
      const email = 'user@example.com';
      const otp = '123456';

      when(mockAuthRepo.verifyOtp(email: email, otp: otp)).thenAnswer(
        (_) async => SuccessResponce(
          VerifyOtpEntity(expiresAtUtc: DateTime.now(), resetToken: 'token123'),
        ),
      );
      VerifyOtpUserCase verifyOtpUserCase = VerifyOtpUserCase(mockAuthRepo);
      // Act
      final result = await verifyOtpUserCase.call(email: email, otp: otp);

      // Assert
      expect(result, isA<SuccessResponce<VerifyOtpEntity>>());
    });

    test('should return ErrorResponce when verify OTP fails', () async {
      // Arrange
      const email = 'user@example.com';
      const otp = 'invalid';

      when(mockAuthRepo.verifyOtp(email: email, otp: otp)).thenAnswer(
        (_) async => ErrorResponce(Exception('Invalid OTP or email')),
      );

      VerifyOtpUserCase verifyOtpUserCase = VerifyOtpUserCase(mockAuthRepo);

      // Act
      final result = await verifyOtpUserCase.call(email: email, otp: otp);

      // Assert
      expect(result, isA<ErrorResponce<VerifyOtpEntity>>());
      verify(mockAuthRepo.verifyOtp(email: email, otp: otp)).called(1);
    });
  });
}
