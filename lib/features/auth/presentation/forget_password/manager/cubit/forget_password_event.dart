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
