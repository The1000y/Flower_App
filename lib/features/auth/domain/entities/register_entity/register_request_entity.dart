import 'package:flower_app/core/constants/app_strings/app_strings.dart';

class RegisterRequestEntity {
  final String fullName;
  final String email;
  final String phoneNumber;
  final int gender;
  final String password;
  final String confirmPassword;

  RegisterRequestEntity({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.password,
    required this.confirmPassword,
  });

  String? validate() {
    if (fullName.trim().isEmpty) return AppStrings.firstNameRequired;
    if (email.trim().isEmpty) return AppStrings.emailRequired;
    if (phoneNumber.trim().isEmpty) return AppStrings.phoneRequired;
    if (password.isEmpty) return AppStrings.passwordRequired;
    if (confirmPassword.isEmpty) return AppStrings.confirmPasswordRequired;
    if (password != confirmPassword) return AppStrings.confirmPasswordMismatch;
    return null;
  }
}