sealed class ForgetPasswordEvent {}

class VerifyOtpEvent extends ForgetPasswordEvent {
  final String email;
  final String otpCode;
  VerifyOtpEvent({required this.otpCode , required this.email});
}

class ResendtOtpEvent extends ForgetPasswordEvent {
  final String email;
  ResendtOtpEvent({required this.email});
}


class ForgetBassEvent extends ForgetPasswordEvent {
  final String email;
  ForgetBassEvent({required this.email});
}

class ResetPasswordEvent extends ForgetPasswordEvent {
  final String newPassword;
  final String resetCode;
  final String email;
  ResetPasswordEvent({
    required this.email,
    required this.newPassword,
    required this.resetCode,
  });
  
}
