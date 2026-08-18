import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:flower_app/features/auth/domain/use_case/forget_password_user_case.dart';
import 'package:flower_app/features/auth/domain/use_case/verify_otp_user_case.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_cubit.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_event.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'forget_password_cubit_test.mocks.dart';

@GenerateMocks([VerifyOtpUserCase, ForgetPasswordUserCase])
void main() {
  late MockVerifyOtpUserCase mockVerifyOtpUserCase;
  late MockForgetPasswordUserCase mockForgetPasswordUserCase;
  late ForgetPasswordCubit forgetPasswordCubit;

  provideDummy<BaseResponce<VerifyOtpEntity>>(
    SuccessResponce(
      VerifyOtpEntity(expiresAtUtc: DateTime.now(), resetToken: ''),
    ),
  );

  provideDummy<BaseResponce<ForgetPasswordEntity>>(
    SuccessResponce(
      ForgetPasswordEntity(isSuccess: true , message: ''),
    ),
  );

  setUp(() {
    mockVerifyOtpUserCase = MockVerifyOtpUserCase();
    mockForgetPasswordUserCase = MockForgetPasswordUserCase();
    forgetPasswordCubit = ForgetPasswordCubit(
      mockVerifyOtpUserCase,
      mockForgetPasswordUserCase,
    );
  });

  tearDown(() {
    forgetPasswordCubit.close();
  });

  group('ForgetPasswordCubit Tests', () {
    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'verifyOtp emits [loading, success] states when use case succeeds',
      build: () {
        when(
          mockVerifyOtpUserCase.call(
            email: anyNamed('email'),
            otp: anyNamed('otp'),
          ),
        ).thenAnswer(
          (_) async => SuccessResponce(
            VerifyOtpEntity(
              expiresAtUtc: DateTime.now(),
              resetToken: 'token123',
            ),
          ),
        );
        return forgetPasswordCubit;
      },
      act: (cubit) => cubit.doEvent(
        VerifyOtpEvent(email: 'test@example.com', otpCode: '123456'),
      ),
      expect: () => [
        // loading state
        isA<ForgetPasswordState>()
            .having((state) => state.otpState.isLoading, 'isLoading', true),
        // success state
        isA<ForgetPasswordState>()
            .having((state) => state.otpState.isLoading, 'isLoading', false)
            .having((state) => state.otpState.data, 'data', isNotNull),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'verifyOtp emits [loading, error] states when use case fails',
      build: () {
        when(
          mockVerifyOtpUserCase.call(
            email: anyNamed('email'),
            otp: anyNamed('otp'),
          ),
        ).thenAnswer(
          (_) async => ErrorResponce(
            Exception('Invalid OTP'),
          ),
        );
        return forgetPasswordCubit;
      },
      act: (cubit) => cubit.doEvent(
        VerifyOtpEvent(email: 'test@example.com', otpCode: 'wrong'),
      ),
      expect: () => [
        // loading state
        isA<ForgetPasswordState>()
            .having((state) => state.otpState.isLoading, 'isLoading', true),
        // error state
        isA<ForgetPasswordState>()
            .having((state) => state.otpState.isLoading, 'isLoading', false)
            .having((state) => state.otpState.errorMessage, 'errorMessage', isNotEmpty),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'resendOtp emits [loading, success] states when use case succeeds',
      build: () {
        when(
          mockForgetPasswordUserCase.call(
            email: anyNamed('email'),
          ),
        ).thenAnswer(
          (_) async => SuccessResponce(
            ForgetPasswordEntity(isSuccess: true, message: 'OTP sent'),
          ),
        );
        return forgetPasswordCubit;
      },
      act: (cubit) => cubit.doEvent(
        ResendtOtpEvent(email: 'test@example.com'),
      ),
      expect: () => [
        // loading state
        isA<ForgetPasswordState>()
            .having((state) => state.resendOtpState.isLoading, 'isLoading', true),
        // success state
        isA<ForgetPasswordState>()
            .having((state) => state.resendOtpState.isLoading, 'isLoading', false)
            .having((state) => state.resendOtpState.data, 'data', isNotNull),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'resendOtp emits [loading, error] states when use case fails',
      build: () {
        when(
          mockForgetPasswordUserCase.call(
            email: anyNamed('email'),
          ),
        ).thenAnswer(
          (_) async => ErrorResponce(
            Exception('Email not found'),
          ),
        );
        return forgetPasswordCubit;
      },
      act: (cubit) => cubit.doEvent(
        ResendtOtpEvent(email: 'notfound@example.com'),
      ),
      expect: () => [
        // loading state
        isA<ForgetPasswordState>()
            .having((state) => state.resendOtpState.isLoading, 'isLoading', true),
        // error state
        isA<ForgetPasswordState>()
            .having((state) => state.resendOtpState.isLoading, 'isLoading', false)
            .having((state) => state.resendOtpState.errorMessage, 'errorMessage', isNotEmpty),
      ],
    );
  });
}