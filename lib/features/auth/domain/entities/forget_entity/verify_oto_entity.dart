class VerifyOtpEntity {
  final String resetToken;
  final DateTime expiresAtUtc;

  VerifyOtpEntity({
    required this.resetToken,
    required this.expiresAtUtc,
  });
}