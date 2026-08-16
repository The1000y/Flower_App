import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';

class ForgotPasswordState {
  BaseState<ForgetPasswordEntity>? forgotstate;
  BaseState<ResetPassswordEntity>? resetstate;
  ForgotPasswordState({this.forgotstate, this.resetstate}) {
    forgotstate ??= BaseState<ForgetPasswordEntity>(isLoading: false);
    resetstate ??= BaseState<ResetPassswordEntity>(isLoading: false);
  }
  
  ForgotPasswordState copyWith({
    BaseState<ForgetPasswordEntity>? forgotpassStateArgument,
    BaseState<ResetPassswordEntity>? resetpassStateArgument,
  }) {
    return ForgotPasswordState(
      forgotstate: forgotpassStateArgument ?? forgotstate,
      resetstate: resetpassStateArgument ?? resetstate,
    );
  }
}
