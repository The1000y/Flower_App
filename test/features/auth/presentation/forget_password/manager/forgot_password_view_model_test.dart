import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:flower_app/features/auth/domain/use_case/forget_password_user_case.dart';
import 'package:flower_app/features/auth/domain/use_case/reset_password_user_case.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/forgot_password_event.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/forgot_password_state.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/forgot_password_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockForgetPasswordUserCase extends Mock
    implements ForgetPasswordUserCase {}

class MockResetPasswordUserCase extends Mock
    implements ResetPasswordUserCase {}

void main() {
  late MockForgetPasswordUserCase forgetPasswordUserCase;
  late MockResetPasswordUserCase resetPasswordUserCase;

  setUp(() {
    forgetPasswordUserCase = MockForgetPasswordUserCase();
    resetPasswordUserCase = MockResetPasswordUserCase();
  });

  group('ForgotPasswordViewModel', () {
    test('initial state should be ForgotPasswordState', () {
      final viewModel = ForgotPasswordViewModel(
        forgetPasswordUserCase,
        resetPasswordUserCase,
      );

      expect(viewModel.state, isA<ForgotPasswordState>());
      expect(viewModel.state.forgotstate!.isLoading, false);
      expect(viewModel.state.resetstate!.isLoading, false);
    });

    blocTest<ForgotPasswordViewModel, ForgotPasswordState>(
      'should emit loading then success when forget password succeeds',
      build: () {
        when(
          () => forgetPasswordUserCase(
            email: 'test@gmail.com',
          ),
        ).thenAnswer(
          (_) async => SuccessResponce(
            ForgetPasswordEntity(
              isSuccess: true,
              message: 'Password reset email sent',
            ),
          ),
        );

        return ForgotPasswordViewModel(
          forgetPasswordUserCase,
          resetPasswordUserCase,
        );
      },
      act: (viewModel) {
        viewModel.doEvent(
          ForgetBassEvent(
            email: 'test@gmail.com',
          ),
        );
      },
      expect: () => [
        isA<ForgotPasswordState>()
            .having(
              (state) => state.forgotstate!.isLoading,
              'isLoading',
              true,
            ),
        isA<ForgotPasswordState>()
            .having(
              (state) => state.forgotstate!.isLoading,
              'isLoading',
              false,
            )
            .having(
              (state) => state.forgotstate!.data!.isSuccess,
              'isSuccess',
              true,
            ),
      ],
      verify: (_) {
        verify(
          () => forgetPasswordUserCase(
            email: 'test@gmail.com',
          ),
        ).called(1);
      },
    );

    blocTest<ForgotPasswordViewModel, ForgotPasswordState>(
      'should emit loading then error when forget password fails',
      build: () {
        when(
          () => forgetPasswordUserCase(
            email: 'wrong@gmail.com',
          ),
        ).thenAnswer(
          (_) async => ErrorResponce(
            Exception('Email not found'),
          ),
        );

        return ForgotPasswordViewModel(
          forgetPasswordUserCase,
          resetPasswordUserCase,
        );
      },
      act: (viewModel) {
        viewModel.doEvent(
          ForgetBassEvent(
            email: 'wrong@gmail.com',
          ),
        );
      },
      expect: () => [
        isA<ForgotPasswordState>()
            .having(
              (state) => state.forgotstate!.isLoading,
              'isLoading',
              true,
            ),
        isA<ForgotPasswordState>()
            .having(
              (state) => state.forgotstate!.isLoading,
              'isLoading',
              false,
            )
            .having(
              (state) => state.forgotstate!.errorMessage,
              'errorMessage',
              'Email not found',
            ),
      ],
      verify: (_) {
        verify(
          () => forgetPasswordUserCase(
            email: 'wrong@gmail.com',
          ),
        ).called(1);
      },
    );

    blocTest<ForgotPasswordViewModel, ForgotPasswordState>(
      'should emit loading then success when reset password succeeds',
      build: () {
        when(
          () => resetPasswordUserCase(
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

        return ForgotPasswordViewModel(
          forgetPasswordUserCase,
          resetPasswordUserCase,
        );
      },
      act: (viewModel) {
        viewModel.doEvent(
          ResetPasswordEvent(
            email: 'test@gmail.com',
            resetCode: '123456',
            newPassword: 'NewPassword@123',
          ),
        );
      },
      expect: () => [
        isA<ForgotPasswordState>()
            .having(
              (state) => state.resetstate!.isLoading,
              'isLoading',
              true,
            ),
        isA<ForgotPasswordState>()
            .having(
              (state) => state.resetstate!.isLoading,
              'isLoading',
              false,
            )
            .having(
              (state) => state.resetstate!.data!.isSuccess,
              'isSuccess',
              true,
            ),
      ],
      verify: (_) {
        verify(
          () => resetPasswordUserCase(
            email: 'test@gmail.com',
            otp: '123456',
            password: 'NewPassword@123',
          ),
        ).called(1);
      },
    );

    blocTest<ForgotPasswordViewModel, ForgotPasswordState>(
      'should emit loading then error when reset password fails',
      build: () {
        when(
          () => resetPasswordUserCase(
            email: 'test@gmail.com',
            otp: 'wrong-otp',
            password: 'NewPassword@123',
          ),
        ).thenAnswer(
          (_) async => ErrorResponce(
            Exception('Invalid OTP'),
          ),
        );

        return ForgotPasswordViewModel(
          forgetPasswordUserCase,
          resetPasswordUserCase,
        );
      },
      act: (viewModel) {
        viewModel.doEvent(
          ResetPasswordEvent(
            email: 'test@gmail.com',
            resetCode: 'wrong-otp',
            newPassword: 'NewPassword@123',
          ),
        );
      },
      expect: () => [
        isA<ForgotPasswordState>()
            .having(
              (state) => state.resetstate!.isLoading,
              'isLoading',
              true,
            ),
        isA<ForgotPasswordState>()
            .having(
              (state) => state.resetstate!.isLoading,
              'isLoading',
              false,
            )
            .having(
              (state) => state.resetstate!.errorMessage,
              'errorMessage',
              'Invalid OTP',
            ),
      ],
      verify: (_) {
        verify(
          () => resetPasswordUserCase(
            email: 'test@gmail.com',
            otp: 'wrong-otp',
            password: 'NewPassword@123',
          ),
        ).called(1);
      },
    );
  });
}