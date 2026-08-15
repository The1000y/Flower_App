import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:flower_app/features/auth/domain/use_case/forget_password_user_case.dart';
import 'package:flower_app/features/auth/domain/use_case/verify_otp_user_case.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_event.dart';
import 'package:flower_app/features/auth/presentation/forget_password/manager/cubit/forget_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit(this._verifyOtpUserCase, this._forgetPasswordUserCase)
    : super(ForgetPasswordState());

  final VerifyOtpUserCase _verifyOtpUserCase;
  final ForgetPasswordUserCase _forgetPasswordUserCase;

  void doEvent(ForgetPasswordEvent event) {
    switch (event) {
      case ResendtOtpEvent():
        _resendOtp(email: event.email);
        break;
      case VerifyOtpEvent():
        _verifyOtp(email: event.email, otp: event.otpCode);
        break;
    }
  }

  void _verifyOtp({required String email, required String otp}) async {
    emit(
      state.copyWith(
        otpState: state.otpState.copyWith(
          isLoading: true,
          data: null,
          errorMessage: '',
        ),
      ),
    );
    final BaseResponce<VerifyOtpEntity> responce = await _verifyOtpUserCase
        .call(email: email, otp: otp);
    switch (responce) {
      case SuccessResponce<VerifyOtpEntity>():
        emit(
          state.copyWith(
            otpState: state.otpState.copyWith(
              isLoading: false,
              data: responce.data,
              errorMessage: '',
            ),
          ),
        );
        break;
      case ErrorResponce<VerifyOtpEntity>():
        emit(
          state.copyWith(
            otpState: state.otpState.copyWith(
              isLoading: false,
              errorMessage: responce.errorMessage,
              data: null,
            ),
          ),
        );
        break;
    }
  }

  void _resendOtp({required String email}) async {
    emit(
      state.copyWith(
        resendOtpState: state.resendOtpState.copyWith(
          isLoading: true,
          data: null,
          errorMessage: '',
        ),
      ),
    );
    final BaseResponce<ForgetPasswordEntity> responce =
        await _forgetPasswordUserCase.call(email: email);

    switch (responce) {
      case SuccessResponce<ForgetPasswordEntity>():
        emit(
          state.copyWith(
            resendOtpState: state.resendOtpState.copyWith(
              isLoading: false,
              data: responce.data,
              errorMessage: '',
            ),
          ),
        );

        break;

      case ErrorResponce<ForgetPasswordEntity>():
        emit(
          state.copyWith(
            resendOtpState: state.resendOtpState.copyWith(
              isLoading: false,
              errorMessage: responce.errorMessage,
              data: null,
            ),
          ),
        );
        break;
    }
  }
}
