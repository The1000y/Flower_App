import 'package:flower_app/l10n/l10n.dart';

class AuthValidators {
  AuthValidators._(); // prevent instantiation

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return L10n.instance.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return L10n.instance.emailInvalid;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return L10n.instance.passwordRequired;
    if (value.length < 8) return L10n.instance.passwordMinLength;
    return null;
  }

  /// Stricter policy for creating a new password (registration / reset),
  /// as opposed to [password] which only checks an existing password is present.
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) return L10n.instance.passwordRequired;
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
    );
    if (!passwordRegex.hasMatch(value)) {
      return L10n.instance.passwordStrongRules;
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return L10n.instance.confirmPasswordRequired;
    }
    if (value != original) return L10n.instance.confirmPasswordMismatch;
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return L10n.instance.usernameRequired;
    }
    if (value.trim().length < 3) {
      return L10n.instance.usernameMinLength;
    }
    return null;
  }

  static String? addressFields(String? value, String errorMessage) {
    if (value == null || value.trim().isEmpty) return errorMessage;
    if (value.trim().length < 3) {
      return errorMessage;
    }
    return null;
  }

  static String? firstName(String? value, [String? errorMessage]) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage ?? L10n.instance.firstNameRequired;
    }
    if (!RegExp(r'^[a-zA-Z]{2,30}$').hasMatch(value)) {
      return L10n.instance.firstNameOnlyLetters;
    }
    return null;
  }

  static String? lastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return L10n.instance.lastNameRequired;
    }
    if (!RegExp(r'^[a-zA-Z]{2,30}$').hasMatch(value)) {
      return L10n.instance.lastNameOnlyLetters;
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return L10n.instance.phoneRequired;
    if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value)) {
      return L10n.instance.phoneInvalid;
    }
    return null;
  }
}
