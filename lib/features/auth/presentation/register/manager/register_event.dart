sealed class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final int gender;

  RegisterEvent({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.gender,
  });
}
