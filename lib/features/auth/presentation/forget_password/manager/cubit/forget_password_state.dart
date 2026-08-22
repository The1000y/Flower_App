import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';

class ForgetPasswordState extends Equatable {
  final BaseState<VerifyOtpEntity> otpState;
  final BaseState<ForgetPasswordEntity> resendOtpState;
  final BaseState<ForgetPasswordEntity> forgotstate;
  final BaseState<ResetPassswordEntity> resetstate;

  const ForgetPasswordState({
    this.forgotstate = const BaseState<ForgetPasswordEntity>(),
    this.resetstate = const BaseState<ResetPassswordEntity>(),
    this.otpState = const BaseState<VerifyOtpEntity>(),
    this.resendOtpState = const BaseState<ForgetPasswordEntity>(),
  });

  ForgetPasswordState copyWith({
    BaseState<VerifyOtpEntity>? otpState,
    BaseState<ForgetPasswordEntity>? resendOtpState,
    BaseState<ForgetPasswordEntity>? forgotstate,
    BaseState<ResetPassswordEntity>? resetstate,
  }) {
    return ForgetPasswordState(
      forgotstate: forgotstate ?? this.forgotstate,
      resetstate: resetstate ?? this.resetstate,
      otpState: otpState ?? this.otpState,
      resendOtpState: resendOtpState ?? this.resendOtpState,
    );
  }

  @override
  List<Object> get props => [otpState, resendOtpState , forgotstate, resetstate];
}
