sealed class ForgotPasswordEvent {}

class ForgetBassEvent extends ForgotPasswordEvent {
  final String email;
  ForgetBassEvent({required this.email});
}

class ResetPasswordEvent extends ForgotPasswordEvent {
  final String newPassword;
  final String resetCode;
  final String email;
  ResetPasswordEvent({
    required this.email,
    required this.newPassword,
    required this.resetCode,
  });

  
}

class VerifyOtpEvent extends ForgotPasswordEvent {
  final String email;
  final String otpCode;
  VerifyOtpEvent({required this.otpCode , required this.email});
}

class ResendtOtpEvent extends ForgotPasswordEvent {
  final String email;
  ResendtOtpEvent({required this.email});
}
