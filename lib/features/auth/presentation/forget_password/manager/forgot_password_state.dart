import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';

class ForgotPasswordState  {
  BaseState<ForgetPasswordEntity>? forgotstate;
  BaseState<ResetPassswordEntity>? resetstate;
   BaseState<VerifyOtpEntity>? otpState;
   BaseState<ForgetPasswordEntity>? resendOtpState;
  ForgotPasswordState({this.forgotstate, this.resetstate,  this.otpState,  this.resendOtpState}) {
    forgotstate ??= BaseState<ForgetPasswordEntity>(isLoading: false);
    resetstate ??= BaseState<ResetPassswordEntity>(isLoading: false);
    otpState ??=   BaseState<VerifyOtpEntity>(isLoading: true);
    resendOtpState =  BaseState<ForgetPasswordEntity>(isLoading: true);
  }
  
  ForgotPasswordState copyWith({
    BaseState<VerifyOtpEntity>? otpState,
    BaseState<ForgetPasswordEntity>? resendOtpState,
    BaseState<ForgetPasswordEntity>? forgotpassStateArgument,
    BaseState<ResetPassswordEntity>? resetpassStateArgument,
  }) {
    return ForgotPasswordState(
      forgotstate: forgotpassStateArgument ?? forgotstate,
      resetstate: resetpassStateArgument ?? resetstate,
      otpState: otpState ?? this.otpState,
      resendOtpState: resendOtpState ?? this.resendOtpState,
    );
  }
}
