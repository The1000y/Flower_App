import 'package:flower_app/features/auth/domain/entities/register_entity/register_request_entity.dart';

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

  factory RegisterRequest.fromEntity(RegisterRequestEntity entity) {
    return RegisterRequest(
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      gender: entity.gender,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
    );
  }

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('firstName') || json.containsKey('lastName')) {
      final firstName = json['firstName']?.toString() ?? '';
      final lastName = json['lastName']?.toString() ?? '';
      return RegisterRequest(
        fullName: '$firstName $lastName'.trim(),
        email: json['email'] as String,
        phoneNumber: json['phoneNumber'] as String,
        gender: _genderFromJson(json['gender']),
        password: json['password'] as String,
        confirmPassword: json['confirmPassword'] as String,
      );
    }
    return RegisterRequest(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      gender: _genderFromJson(json['gender']),
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender == 1 ? 'Female' : 'Male',
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }

  RegisterRequestEntity toRegisterRequestEntity() {
    return RegisterRequestEntity(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      gender: gender,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  static int _genderFromJson(dynamic value) {
    if (value is num) return value.toInt();
    final raw = value?.toString().toLowerCase() ?? '';
    if (raw == 'female' || raw == '1') return 1;
    return 0;
  }
}
