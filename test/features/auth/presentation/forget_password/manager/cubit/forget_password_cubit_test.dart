import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:flower_app/features/auth/domain/use_case/forget_password_user_case.dart';
import 'package:flower_app/features/auth/domain/use_case/reset_password_user_case.dart';
import 'package:flower_app/features/auth/domain/use_case/verify_otp_user_case.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_cubit.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_event.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockForgetPasswordUserCase extends Mock
    implements ForgetPasswordUserCase {}

class MockResetPasswordUserCase extends Mock
    implements ResetPasswordUserCase {}

class MockVerifyOtpUserCase extends Mock
    implements VerifyOtpUserCase {}

void main() {
  late MockForgetPasswordUserCase mockForgetPasswordUserCase;
  late MockResetPasswordUserCase mockResetPasswordUserCase;
  late MockVerifyOtpUserCase mockVerifyOtpUserCase;

  setUp(() {
    mockForgetPasswordUserCase = MockForgetPasswordUserCase();
    mockResetPasswordUserCase = MockResetPasswordUserCase();
    mockVerifyOtpUserCase = MockVerifyOtpUserCase();
  });

  group('ForgetPasswordCubit', () {
    test('initial state should be ForgetPasswordState with loading false', () {
      final cubit = ForgetPasswordCubit(
        mockVerifyOtpUserCase,
        mockForgetPasswordUserCase,
        mockResetPasswordUserCase,
      );

      expect(cubit.state, isA<ForgetPasswordState>());
    });

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'should emit loading then success when forget password succeeds',
      build: () {
        when(
          () => mockForgetPasswordUserCase.call(email: 'test@gmail.com'),
        ).thenAnswer(
          (_) async => SuccessResponce(
            ForgetPasswordEntity(
              isSuccess: true,
              message: 'Password reset email sent',
            ),
          ),
        );

        return ForgetPasswordCubit(
          mockVerifyOtpUserCase,
          mockForgetPasswordUserCase,
          mockResetPasswordUserCase,
        );
      },
      act: (cubit) {
        cubit.doEvent(
          ForgetBassEvent(
            email: 'test@gmail.com',
          ),
        );
      },
      expect: () => [
        isA<ForgetPasswordState>()
            .having(
              (state) => state.forgotstate.isLoading,
              'isLoading',
              true,
            ),
        isA<ForgetPasswordState>()
            .having(
              (state) => state.forgotstate.isLoading,
              'isLoading',
              false,
            )
            .having(
              (state) => state.forgotstate.data?.isSuccess,
              'isSuccess',
              true,
            ),
      ],
      verify: (_) {
        verify(
          () => mockForgetPasswordUserCase.call(email: 'test@gmail.com'),
        ).called(1);
      },
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'should emit loading then error when forget password fails',
      build: () {
        when(
          () => mockForgetPasswordUserCase.call(email: 'wrong@gmail.com'),
        ).thenAnswer(
          (_) async => ErrorResponce(
            Exception('something went wrong, pls try again'),
          ),
        );

        return ForgetPasswordCubit(
          mockVerifyOtpUserCase,
          mockForgetPasswordUserCase,
          mockResetPasswordUserCase,
        );
      },
      act: (cubit) {
        cubit.doEvent(
          ForgetBassEvent(
            email: 'wrong@gmail.com',
          ),
        );
      },
      expect: () => [
        isA<ForgetPasswordState>()
            .having(
              (state) => state.forgotstate.isLoading,
              'isLoading',
              true,
            ),
        isA<ForgetPasswordState>()
            .having(
              (state) => state.forgotstate.isLoading,
              'isLoading',
              false,
            )
            .having(
              (state) => state.forgotstate.errorMessage,
              'errorMessage',
              isNotEmpty,
            ),
      ],
      verify: (_) {
        verify(
          () => mockForgetPasswordUserCase.call(email: 'wrong@gmail.com'),
        ).called(1);
      },
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'should emit loading then success when reset password succeeds',
      build: () {
        when(
          () => mockResetPasswordUserCase.call(
            email: 'test@gmail.com',
            otp: '123456',
            password: 'NewPassword@123',
          ),
        ).thenAnswer(
          (_) async => SuccessResponce(
            ResetPassswordEntity(
              isSuccess: true,
              message: 'Password reset successfully',
            ),
          ),
        );

        return ForgetPasswordCubit(
          mockVerifyOtpUserCase,
          mockForgetPasswordUserCase,
          mockResetPasswordUserCase,
        );
      },
      act: (cubit) {
        cubit.doEvent(
          ResetPasswordEvent(
            email: 'test@gmail.com',
            resetCode: '123456',
            newPassword: 'NewPassword@123',
          ),
        );
      },
      expect: () => [
        isA<ForgetPasswordState>()
            .having(
              (state) => state.resetstate.isLoading,
              'isLoading',
              true,
            ),
        isA<ForgetPasswordState>()
            .having(
              (state) => state.resetstate.isLoading,
              'isLoading',
              false,
            )
            .having(
              (state) => state.resetstate.data?.isSuccess,
              'isSuccess',
              true,
            ),
      ],
      verify: (_) {
        verify(
          () => mockResetPasswordUserCase.call(
            email: 'test@gmail.com',
            otp: '123456',
            password: 'NewPassword@123',
          ),
        ).called(1);
      },
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'should emit loading then error when reset password fails',
      build: () {
        when(
          () => mockResetPasswordUserCase.call(
            email: 'test@gmail.com',
            otp: 'wrong-otp',
            password: 'NewPassword@123',
          ),
        ).thenAnswer(
          (_) async => ErrorResponce(
            Exception('Invalid OTP'),
          ),
        );

        return ForgetPasswordCubit(
          mockVerifyOtpUserCase,
          mockForgetPasswordUserCase,
          mockResetPasswordUserCase,
        );
      },
      act: (cubit) {
        cubit.doEvent(
          ResetPasswordEvent(
            email: 'test@gmail.com',
            resetCode: 'wrong-otp',
            newPassword: 'NewPassword@123',
          ),
        );
      },
      expect: () => [
        isA<ForgetPasswordState>()
            .having(
              (state) => state.resetstate.isLoading,
              'isLoading',
              true,
            ),
        isA<ForgetPasswordState>()
            .having(
              (state) => state.resetstate.isLoading,
              'isLoading',
              false,
            )
            .having(
              (state) => state.resetstate.errorMessage,
              'errorMessage',
              isNotEmpty,
            ),
      ],
      verify: (_) {
        verify(
          () => mockResetPasswordUserCase.call(
            email: 'test@gmail.com',
            otp: 'wrong-otp',
            password: 'NewPassword@123',
          ),
        ).called(1);
      },
    );
  });
}