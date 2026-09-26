import 'package:flower_app/features/auth/data/model/request/forget_request/reset_password_request_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResetPasswordRequestDto', () {
    test('should create ResetPasswordRequestDto from JSON correctly', () {
      final json = {
        'resetToken': '123456',
        'newPassword': 'Password123!',
        'confirmPassword': 'Password123!',
      };

      final result = ResetPasswordRequestDto.fromJson(json);

      expect(result.resetToken, '123456');
      expect(result.newPassword, 'Password123!');
      expect(result.confirmPassword, 'Password123!');
    });

    test('should convert ResetPasswordRequestDto to JSON correctly', () {
      const dto = ResetPasswordRequestDto(
        resetToken: '123456',
        newPassword: 'Password123!',
        confirmPassword: 'Password123!',
      );

      final result = dto.toJson();

      expect(result['resetToken'], '123456');
      expect(result['newPassword'], 'Password123!');
      expect(result['confirmPassword'], 'Password123!');
    });
  });
}