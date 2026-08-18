import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/forgot_password_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ForgotPasswordState', () {
    test('should create default states when no states are provided', () {
      final state = ForgotPasswordState();

      expect(state.forgotstate, isNotNull);
      expect(state.resetstate, isNotNull);

      expect(state.forgotstate!.isLoading, false);
      expect(state.resetstate!.isLoading, false);
    });

    test('should create state with provided states', () {
      final forgotState = BaseState<ForgetPasswordEntity>(
        isLoading: true,
      );

      final resetState = BaseState<ResetPassswordEntity>(
        isLoading: true,
      );

      final state = ForgotPasswordState(
        forgotstate: forgotState,
        resetstate: resetState,
      );

      expect(state.forgotstate, forgotState);
      expect(state.resetstate, resetState);

      expect(state.forgotstate!.isLoading, true);
      expect(state.resetstate!.isLoading, true);
    });

    test('should copy state with new forgot password state', () {
      final oldState = ForgotPasswordState();

      final newForgotState = BaseState<ForgetPasswordEntity>(
        isLoading: true,
      );

      final newState = oldState.copyWith(
        forgotpassStateArgument: newForgotState,
      );

      expect(newState.forgotstate, newForgotState);
      expect(newState.resetstate, oldState.resetstate);
    });

    test('should copy state with new reset password state', () {
      final oldState = ForgotPasswordState();

      final newResetState = BaseState<ResetPassswordEntity>(
        isLoading: true,
      );

      final newState = oldState.copyWith(
        resetpassStateArgument: newResetState,
      );

      expect(newState.resetstate, newResetState);
      expect(newState.forgotstate, oldState.forgotstate);
    });
  });
}