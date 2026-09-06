import 'package:flower_app/config/utils/auth_validators.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthValidators.email', () {
    test('returns emailRequired for null', () {
      expect(AuthValidators.email(null), AppStrings.emailRequired);
    });

    test('returns emailRequired for empty/whitespace', () {
      expect(AuthValidators.email(''), AppStrings.emailRequired);
      expect(AuthValidators.email('   '), AppStrings.emailRequired);
    });

    test('returns emailInvalid for malformed emails', () {
      expect(AuthValidators.email('invalid-email'), AppStrings.emailInvalid);
      expect(AuthValidators.email('a@b'), AppStrings.emailInvalid);
      expect(AuthValidators.email('@domain.com'), AppStrings.emailInvalid);
    });

    test('returns null for valid email', () {
      expect(AuthValidators.email('user@example.com'), isNull);
      expect(AuthValidators.email('  user@example.com  '), isNull);
    });
  });

  group('AuthValidators.password', () {
    test('returns passwordRequired for null/empty', () {
      expect(AuthValidators.password(null), AppStrings.passwordRequired);
      expect(AuthValidators.password(''), AppStrings.passwordRequired);
    });

    test('returns passwordMinLength for short passwords', () {
      expect(AuthValidators.password('1234567'), AppStrings.passwordMinLength);
    });

    test('returns null for 8+ char password', () {
      expect(AuthValidators.password('12345678'), isNull);
    });
  });

  group('AuthValidators.strongPassword', () {
    test('returns passwordRequired for empty', () {
      expect(AuthValidators.strongPassword(''), AppStrings.passwordRequired);
    });

    test('returns passwordStrongRules for weak passwords', () {
      expect(AuthValidators.strongPassword('password'), AppStrings.passwordStrongRules);
      expect(AuthValidators.strongPassword('PASSWORD1'), AppStrings.passwordStrongRules);
      expect(AuthValidators.strongPassword('Passw1'), AppStrings.passwordStrongRules);
    });

    test('returns null for strong password', () {
      expect(AuthValidators.strongPassword('Passw0rd!'), isNull);
    });
  });

  group('AuthValidators.confirmPassword', () {
    test('returns confirmPasswordRequired for empty', () {
      expect(
        AuthValidators.confirmPassword('', 'Password1!'),
        AppStrings.confirmPasswordRequired,
      );
    });

    test('returns confirmPasswordMismatch when mismatch', () {
      expect(
        AuthValidators.confirmPassword('Different!', 'Password1!'),
        AppStrings.confirmPasswordMismatch,
      );
    });

    test('returns null when passwords match', () {
      expect(AuthValidators.confirmPassword('Password1!', 'Password1!'), isNull);
    });
  });

  group('AuthValidators.username', () {
    test('returns usernameRequired for empty', () {
      expect(AuthValidators.username(null), AppStrings.usernameRequired);
      expect(AuthValidators.username(''), AppStrings.usernameRequired);
    });

    test('returns usernameMinLength for short', () {
      expect(AuthValidators.username('ab'), AppStrings.usernameMinLength);
    });

    test('returns null for valid', () {
      expect(AuthValidators.username('mariam'), isNull);
    });
  });

  group('AuthValidators.firstName/lastName', () {
    test('returns firstNameRequired for empty', () {
      expect(AuthValidators.firstName(''), AppStrings.firstNameRequired);
    });

    test('returns firstNameOnlyLetters for digits', () {
      expect(
        AuthValidators.firstName('123'),
        AppStrings.firstNameOnlyLetters,
      );
    });

    test('returns null for valid first name', () {
      expect(AuthValidators.firstName('Mariam'), isNull);
    });

    test('returns lastNameRequired for empty', () {
      expect(AuthValidators.lastName(''), AppStrings.lastNameRequired);
    });

    test('returns null for valid last name', () {
      expect(AuthValidators.lastName('Ahmed'), isNull);
    });
  });

  group('AuthValidators.phone', () {
    test('returns phoneRequired for empty', () {
      expect(AuthValidators.phone(''), AppStrings.phoneRequired);
    });

    test('returns phoneInvalid for wrong format', () {
      expect(AuthValidators.phone('123'), AppStrings.phoneInvalid);
      expect(AuthValidators.phone('0123456789'), AppStrings.phoneInvalid);
    });

    test('returns null for valid Egyptian phone', () {
      expect(AuthValidators.phone('01001112222'), isNull);
      expect(AuthValidators.phone('01112345678'), isNull);
      expect(AuthValidators.phone('01212345678'), isNull);
      expect(AuthValidators.phone('01512345678'), isNull);
    });
  });
}