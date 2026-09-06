import 'package:flower_app/features/auth/data/model/request/forget_request/forgot_password_request_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ForgotPasswordRequestDto', () {
    test('should create ForgotPasswordRequestDto from JSON correctly', () {
      final json = {
        'email': 'test@gmail.com',
      };

      final result = ForgotPasswordRequestDto.fromJson(json);

      expect(result.email, 'test@gmail.com');
    });

    test('should convert ForgotPasswordRequestDto to JSON correctly', () {
      const dto = ForgotPasswordRequestDto(
        email: 'test@gmail.com',
      );

      final result = dto.toJson();

      expect(result['email'], 'test@gmail.com');
    });
  });
}