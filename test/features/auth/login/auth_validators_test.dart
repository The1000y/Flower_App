import 'package:flower_app/config/utils/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flower_app/l10n/app_localizations_en.dart';

void main() {
  group('AuthValidators.email', () {
    test('returns emailRequired for null', () {
      expect(AuthValidators.email(null), AppLocalizationsEn().emailRequired);
    });

    test('returns emailRequired for empty/whitespace', () {
      expect(AuthValidators.email(''), AppLocalizationsEn().emailRequired);
      expect(AuthValidators.email('   '), AppLocalizationsEn().emailRequired);
    });

    test('returns emailInvalid for malformed emails', () {
      expect(AuthValidators.email('invalid-email'), AppLocalizationsEn().emailInvalid);
      expect(AuthValidators.email('a@b'), AppLocalizationsEn().emailInvalid);
      expect(AuthValidators.email('@domain.com'), AppLocalizationsEn().emailInvalid);
    });

    test('returns null for valid email', () {
      expect(AuthValidators.email('user@example.com'), isNull);
      expect(AuthValidators.email('  user@example.com  '), isNull);
    });
  });

  group('AuthValidators.password', () {
    test('returns passwordRequired for null/empty', () {
      expect(AuthValidators.password(null), AppLocalizationsEn().passwordRequired);
      expect(AuthValidators.password(''), AppLocalizationsEn().passwordRequired);
    });

    test('returns passwordMinLength for short passwords', () {
      expect(AuthValidators.password('1234567'), AppLocalizationsEn().passwordMinLength);
    });

    test('returns null for 8+ char password', () {
      expect(AuthValidators.password('12345678'), isNull);
    });
  });

  group('AuthValidators.strongPassword', () {
    test('returns passwordRequired for empty', () {
      expect(AuthValidators.strongPassword(''), AppLocalizationsEn().passwordRequired);
    });

    test('returns passwordStrongRules for weak passwords', () {
      expect(
        AuthValidators.strongPassword('password'),
        AppLocalizationsEn().passwordStrongRules,
      );
      expect(
        AuthValidators.strongPassword('PASSWORD1'),
        AppLocalizationsEn().passwordStrongRules,
      );
      expect(
        AuthValidators.strongPassword('Passw1'),
        AppLocalizationsEn().passwordStrongRules,
      );
    });

    test('returns null for strong password', () {
      expect(AuthValidators.strongPassword('Passw0rd!'), isNull);
    });
  });

  group('AuthValidators.confirmPassword', () {
    test('returns confirmPasswordRequired for empty', () {
      expect(
        AuthValidators.confirmPassword('', 'Password1!'),
        AppLocalizationsEn().confirmPasswordRequired,
      );
    });

    test('returns confirmPasswordMismatch when mismatch', () {
      expect(
        AuthValidators.confirmPassword('Different!', 'Password1!'),
        AppLocalizationsEn().confirmPasswordMismatch,
      );
    });

    test('returns null when passwords match', () {
      expect(
        AuthValidators.confirmPassword('Password1!', 'Password1!'),
        isNull,
      );
    });
  });

  group('AuthValidators.username', () {
    test('returns usernameRequired for empty', () {
      expect(AuthValidators.username(null), AppLocalizationsEn().usernameRequired);
      expect(AuthValidators.username(''), AppLocalizationsEn().usernameRequired);
    });

    test('returns usernameMinLength for short', () {
      expect(AuthValidators.username('ab'), AppLocalizationsEn().usernameMinLength);
    });

    test('returns null for valid', () {
      expect(AuthValidators.username('mariam'), isNull);
    });
  });

  group('AuthValidators.firstName/lastName', () {
    test('returns firstNameRequired for empty', () {
      expect(AuthValidators.firstName(''), AppLocalizationsEn().firstNameRequired);
    });

    test('returns firstNameOnlyLetters for digits', () {
      expect(AuthValidators.firstName('123'), AppLocalizationsEn().firstNameOnlyLetters);
    });

    test('returns null for valid first name', () {
      expect(AuthValidators.firstName('Mariam'), isNull);
    });

    test('returns lastNameRequired for empty', () {
      expect(AuthValidators.lastName(''), AppLocalizationsEn().lastNameRequired);
    });

    test('returns null for valid last name', () {
      expect(AuthValidators.lastName('Ahmed'), isNull);
    });
  });

  group('AuthValidators.phone', () {
    test('returns phoneRequired for empty', () {
      expect(AuthValidators.phone(''), AppLocalizationsEn().phoneRequired);
    });

    test('returns phoneInvalid for wrong format', () {
      expect(AuthValidators.phone('123'), AppLocalizationsEn().phoneInvalid);
      expect(AuthValidators.phone('0123456789'), AppLocalizationsEn().phoneInvalid);
    });

    test('returns null for valid Egyptian phone', () {
      expect(AuthValidators.phone('01001112222'), isNull);
      expect(AuthValidators.phone('01112345678'), isNull);
      expect(AuthValidators.phone('01212345678'), isNull);
      expect(AuthValidators.phone('01512345678'), isNull);
    });
  });
}
