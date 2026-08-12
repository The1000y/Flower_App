import '../../domain/entities/register_params.dart';

class RegisterRequest {
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String phone;
  final String gender;

  RegisterRequest({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.phone,
    required this.gender,
  });

  factory RegisterRequest.fromParams(RegisterParams params) {
    return RegisterRequest(
      firstname: params.firstName,
      lastname: params.lastName,
      email: params.email,
      password: params.password,
      phone: params.phone,
      gender: params.gender,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'phone': phone,
      'gender': gender,
    };
  }
}
