import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:flower_app/features/auth/domain/use_case/forget_password_user_case.dart';
import 'package:flower_app/features/auth/domain/use_case/verify_otp_user_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/use_case/reset_password_user_case.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

@injectable
class ForgotPasswordViewModel extends Cubit<ForgotPasswordState> {
  final ForgetPasswordUserCase forgetPasswordUserCase;
  final ResetPasswordUserCase resetPasswordUserCase;
  final VerifyOtpUserCase  verifyOtpUserCase;

  ForgotPasswordViewModel(
    this.verifyOtpUserCase,
    this.forgetPasswordUserCase,
    this.resetPasswordUserCase,
  ) : super(ForgotPasswordState());

  void doEvent(ForgotPasswordEvent event) {
    switch (event) {
      case ForgetBassEvent():
        _forgetPassword(event);
        break;

      case ResetPasswordEvent():
        _resetPassword(event);
        break;
      case VerifyOtpEvent():
        _verifyOtp(email: event.email, otp: event.otpCode);
      case ResendtOtpEvent():
        _resendOtp(email: event.email);
    }
  }

  Future<void> _forgetPassword(ForgetBassEvent event) async {
    emit(
      state.copyWith(
        forgotpassStateArgument: state.forgotstate?.copyWith(
          isLoading: true,
          errorMessage: "",
        ),
      ),
    );

    final response = await forgetPasswordUserCase(email: event.email);

    switch (response) {
      case SuccessResponce<ForgetPasswordEntity>():
        emit(
          state.copyWith(
            forgotpassStateArgument: state.forgotstate?.copyWith(
              isLoading: false,
              data: response.data,
            ),
          ),
        );
        break;

      case ErrorResponce<ForgetPasswordEntity>():
        emit(
          state.copyWith(
            forgotpassStateArgument: state.forgotstate?.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }

  Future<void> _resetPassword(ResetPasswordEvent event) async {
    emit(
      state.copyWith(
        resetpassStateArgument: state.resetstate?.copyWith(
          isLoading: true,
          errorMessage: "",
        ),
      ),
    );

    final response = await resetPasswordUserCase(
      email: event.email,
      otp: event.resetCode,
      password: event.newPassword,
    );

    switch (response) {
      case SuccessResponce<ResetPassswordEntity>():
        emit(
          state.copyWith(
            resetpassStateArgument: state.resetstate?.copyWith(
              isLoading: false,
              data: response.data,
            ),
          ),
        );
        break;

      case ErrorResponce<ResetPassswordEntity>():
        emit(
          state.copyWith(
            resetpassStateArgument: state.resetstate?.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }

  void _verifyOtp({required String email, required String otp}) async {
    emit(
      state.copyWith(
        otpState: state.otpState?.copyWith(
          isLoading: true,
          data: null,
          errorMessage: '',
        ),
      ),
    );
    final BaseResponce<VerifyOtpEntity> responce = await verifyOtpUserCase
        .call(email: email, otp: otp);
    switch (responce) {
      case SuccessResponce<VerifyOtpEntity>():
        emit(
          state.copyWith(
            otpState: state.otpState?.copyWith(
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
            otpState: state.otpState?.copyWith(
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
        resendOtpState: state.resendOtpState?.copyWith(
          isLoading: true,
          data: null,
          errorMessage: '',
        ),
      ),
    );
    final BaseResponce<ForgetPasswordEntity> responce =
        await forgetPasswordUserCase.call(email: email);

    switch (responce) {
      case SuccessResponce<ForgetPasswordEntity>():
        emit(
          state.copyWith(
            resendOtpState: state.resendOtpState?.copyWith(
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
            resendOtpState: state.resendOtpState?.copyWith(
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
