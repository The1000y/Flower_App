import 'package:flower_app/features/auth/data/model/request/forget_request/reset_password_request_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResetPasswordRequestDto', () {
    test('should create ResetPasswordRequestDto from JSON correctly', () {
      final json = {
        'email': 'test@gmail.com',
        'resetCode': '123456',
        'newPassword': 'A12320022',
      };

      final result = ResetPasswordRequestDto.fromJson(json);

      expect(result.email, 'test@gmail.com');
      expect(result.resetCode, '123456');
      expect(result.newPassword, 'A12320022');
    });

    test('should convert ResetPasswordRequestDto to JSON correctly', () {
      const dto = ResetPasswordRequestDto(
        email: 'test@gmail.com',
        resetCode: '123456',
        newPassword: 'A12320022',
      );

      final result = dto.toJson();

      expect(result['email'], 'test@gmail.com');
      expect(result['resetCode'], '123456');
      expect(result['newPassword'], 'A12320022');
    });
  });
}