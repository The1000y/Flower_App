import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/forgot_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/reset_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/forgot_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/reset_password_response_dto.dart';
import 'package:flower_app/features/auth/data/repo_impl/auth_repo-impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

void main() {
   setUpAll(() {
    registerFallbackValue(
      ForgotPasswordRequestDto(
        email: 'test@gmail.com',
      ),
    );

    registerFallbackValue(
      ResetPasswordRequestDto(
        email: 'test@gmail.com',
        newPassword: 'Password123',
        resetCode: '123456',
      ),
    );
  });
  late MockLocalDataSource localDataSource;
  late AuthRepoimpl authRepo;

  setUp(() {
    localDataSource = MockLocalDataSource();
    authRepo = AuthRepoimpl(localDataSource);
  });

  group('forgetPassword', () {
    test('should return SuccessResponce when localDataSource succeeds', () async {
      final responseDto = ForgotPasswordResponseDto(
        data: 'success',
        message: 'Password reset email sent',
        errorCode: '',
        isSuccess: true,
      );

      when(
        () => localDataSource.forgotPassword(
          any<ForgotPasswordRequestDto>(),
        ),
      ).thenAnswer(
        (_) async => SuccessResponce(responseDto),
      );

      final result = await authRepo.forgetPassword(
        email: 'test@gmail.com',
      );

      expect(result, isA<SuccessResponce>());

      final success = result as SuccessResponce;

      expect(success.data.isSuccess, true);
      expect(success.data.message, 'Password reset email sent');

      verify(
        () => localDataSource.forgotPassword(
          any<ForgotPasswordRequestDto>(),
        ),
      ).called(1);
    });

    test('should return ErrorResponce when localDataSource fails', () async {
      final exception = Exception('Something went wrong');

      when(
        () => localDataSource.forgotPassword(
          any<ForgotPasswordRequestDto>(),
        ),
      ).thenAnswer(
        (_) async => ErrorResponce(exception),
      );

      final result = await authRepo.forgetPassword(
        email: 'test@gmail.com',
      );

      expect(result, isA<ErrorResponce>());

      final error = result as ErrorResponce;

      expect(error.error, exception);

      verify(
        () => localDataSource.forgotPassword(
          any<ForgotPasswordRequestDto>(),
        ),
      ).called(1);
    });
  });

  group('resetPassword', () {
    test('should return SuccessResponce when localDataSource succeeds', () async {
      final responseDto = ResetPasswordResponseDto(
        data: 'success',
        message: 'Password reset successfully',
        errorCode: '',
        isSuccess: true,
      );

      when(
        () => localDataSource.resetPassword(
          any<ResetPasswordRequestDto>(),
        ),
      ).thenAnswer(
        (_) async => SuccessResponce(responseDto),
      );

      final result = await authRepo.resetPassword(
        email: 'test@gmail.com',
        otp: '123456',
        password: 'Password123',
      );

      expect(result, isA<SuccessResponce>());

      final success = result as SuccessResponce;

      expect(success.data.isSuccess, true);
      expect(success.data.message, 'Password reset successfully');

      verify(
        () => localDataSource.resetPassword(
          any<ResetPasswordRequestDto>(),
        ),
      ).called(1);
    });

    test('should return ErrorResponce when localDataSource fails', () async {
      final exception = Exception('Something went wrong');

      when(
        () => localDataSource.resetPassword(
          any<ResetPasswordRequestDto>(),
        ),
      ).thenAnswer(
        (_) async => ErrorResponce(exception),
      );

      final result = await authRepo.resetPassword(
        email: 'test@gmail.com',
        otp: '123456',
        password: 'Password123',
      );

      expect(result, isA<ErrorResponce>());

      final error = result as ErrorResponce;

      expect(error.error, exception);

      verify(
        () => localDataSource.resetPassword(
          any<ResetPasswordRequestDto>(),
        ),
      ).called(1);
    });
  });
}