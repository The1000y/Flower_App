import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';


class ForgetPasswordState extends Equatable {
  final BaseState<VerifyOtpEntity> otpState;
  final BaseState<ForgetPasswordEntity> resendOtpState;

  const ForgetPasswordState({
    this.otpState = const BaseState(isLoading: true),
    this.resendOtpState = const BaseState(isLoading: true),
  });

  ForgetPasswordState copyWith({
    BaseState<VerifyOtpEntity>? otpState,
    BaseState<ForgetPasswordEntity>? resendOtpState,
  }) {
    return ForgetPasswordState(
      otpState: otpState ?? this.otpState,
      resendOtpState: resendOtpState ?? this.resendOtpState,
    );
  }

  @override
  List<Object> get props => [otpState, resendOtpState];
}