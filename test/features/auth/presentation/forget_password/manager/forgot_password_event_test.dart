import 'package:flower_app/features/auth/presentation/forget_password/manager/forgot_password_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ForgotPasswordEvent', () {
    group('ForgetBassEvent', () {
      test('should create ForgetBassEvent with correct email', () {
        final event = ForgetBassEvent(
          email: 'test@gmail.com',
        );

        expect(event.email, 'test@gmail.com');
      });
    });

    group('ResetPasswordEvent', () {
      test('should create ResetPasswordEvent with correct data', () {
        final event = ResetPasswordEvent(
          email: 'test@gmail.com',
          newPassword: 'A12320022',
          resetCode: '123456',
        );

        expect(event.email, 'test@gmail.com');
        expect(event.newPassword, 'A12320022');
        expect(event.resetCode, '123456');
      });
    });
  });
}