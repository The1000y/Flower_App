import 'package:flower_app/core/constants/app_strings/app_strings.dart';

class AuthValidators {
  AuthValidators._(); // prevent instantiation

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.emailRequired;
    final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(value.trim())) return AppStrings.emailInvalid;
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return AppStrings.passwordRequired;
    if (value.length < 8) return AppStrings.passwordMinLength;
    return null;
  }

  /// Stricter policy for creating a new password (registration / reset),
  /// as opposed to [password] which only checks an existing password is present.
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.passwordRequired;
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
    );
    if (!passwordRegex.hasMatch(value)) {
      return AppStrings.passwordStrongRules;
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return AppStrings.confirmPasswordRequired;
    if (value != original) return AppStrings.confirmPasswordMismatch;
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.usernameRequired;
    if (value.trim().length < 3) {
      return AppStrings.usernameMinLength;
    }
    return null;
  }
  static String? addressFields(String? value , String errorMessage) {
    if (value == null || value.trim().isEmpty) return errorMessage;
    if (value.trim().length < 3) {
      return errorMessage;
    }
    return null;
  }

  static String? firstName(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.firstNameRequired;
    if (!RegExp(r'^[a-zA-Z]{2,30}$').hasMatch(value)) {
      return AppStrings.firstNameOnlyLetters;
    }
    return null;
  }

  static String? lastName(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.lastNameRequired;
    if (!RegExp(r'^[a-zA-Z]{2,30}$').hasMatch(value)) {
      return AppStrings.lastNameOnlyLetters;
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return AppStrings.phoneRequired;
    if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value)) {
      return AppStrings.phoneInvalid;
    }
    return null;
  }
}
