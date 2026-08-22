import 'package:equatable/equatable.dart';

class RegisterRequestEntity extends Equatable {
  final String fullName;
  final String email;
  final String phoneNumber;
  final int gender;
  final String password;
  final String confirmPassword;

  const RegisterRequestEntity({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [
        fullName,
        email,
        phoneNumber,
        gender,
        password,
        confirmPassword,
      ];
}