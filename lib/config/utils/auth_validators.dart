class AuthValidators {
  AuthValidators._(); // prevent instantiation

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  /// Stricter policy for creating a new password (registration / reset),
  /// as opposed to [password] which only checks an existing password is present.
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
    );
    if (!passwordRegex.hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, number and special character';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != original) return 'Passwords do not match';
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username is required';
    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  static String? firstName(String? value) {
    if (value == null || value.trim().isEmpty) return 'First name is required';
    if (!RegExp(r'^[a-zA-Z]{2,30}$').hasMatch(value)) {
      return 'First name must contain only letters';
    }
    return null;
  }

  static String? lastName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Last name is required';
    if (!RegExp(r'^[a-zA-Z]{2,30}$').hasMatch(value)) {
      return 'Last name must contain only letters';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value)) {
      return 'Enter a valid Egyptian phone number';
    }
    return null;
  }
}
