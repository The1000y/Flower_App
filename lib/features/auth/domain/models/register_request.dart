import '../entities/register_entity/register_params.dart';

class RegisterRequest {
  final String fullName;
  final String email;
  final String phoneNumber;
  final int gender;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.password,
    required this.confirmPassword,
  });

  factory RegisterRequest.fromParams(RegisterParams params) {
    return RegisterRequest(
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      gender: params.gender,
      password: params.password,
      confirmPassword: params.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
