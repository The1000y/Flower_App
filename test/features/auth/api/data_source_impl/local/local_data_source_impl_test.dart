import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/api/data_source_impl/local/local_data_source_impl.dart';

import 'package:flower_app/features/auth/data/model/request/forget_request/verify_otp_request.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/verify_otp_response.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  late LocalDataSourceImpl localDataSourceImpl;

  setUp(() {
    localDataSourceImpl = LocalDataSourceImpl();
  });

  group('LocalDataSourceImpl Tests', () {
    test('verifyOtp should return SuccessResponce with valid email and otp',
        () async {
      // Arrange
      const request = VerifyOtpRequest(
        email: 'user@example.com',
        otp: '123456',
      );

      // Act
      final result = await localDataSourceImpl.verifyOtp(
        verifyOtpRequest: request,
      );

      // Assert
      expect(result, isA<SuccessResponce<VerifyOtpResponse>>());
      if (result is SuccessResponce<VerifyOtpResponse>) {
        expect(result.data.isSuccess, true);
        expect(result.data.errorCode, 0);
        expect(result.data.data?.resetToken, isNotNull);
      }
    });

    test('verifyOtp should return ErrorResponce with invalid otp', () async {
      // Arrange
      const request = VerifyOtpRequest(
        email: 'user@example.com',
        otp: 'invalid',
      );

      // Act
      final result = await localDataSourceImpl.verifyOtp(
        verifyOtpRequest: request,
      );

      // Assert
      expect(result, isA<ErrorResponce<VerifyOtpResponse>>());
    });

    test('verifyOtp should return ErrorResponce with invalid email', () async {
      // Arrange
      const request = VerifyOtpRequest(
        email: 'wrong@example.com',
        otp: '123456',
      );

      // Act
      final result = await localDataSourceImpl.verifyOtp(
        verifyOtpRequest: request,
      );

      // Assert
      expect(result, isA<ErrorResponce<VerifyOtpResponse>>());
    });
  });
}