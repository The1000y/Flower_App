import 'package:flower_app/features/auth/data/model/responce/forget_responce/forgot_password_response_dto.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ForgotPasswordResponseDto', () {
    test('should create ForgotPasswordResponseDto from JSON correctly', () {
      final json = {
        'data': 'success',
        'message': 'Password reset email sent',
        'errorCode': '',
        'isSuccess': true,
      };

      final result = ForgotPasswordResponseDto.fromJson(json);

      expect(result.data, 'success');
      expect(result.message, 'Password reset email sent');
      expect(result.errorCode, '');
      expect(result.isSuccess, true);
    });

    test('should convert ForgotPasswordResponseDto to JSON correctly', () {
      final dto = ForgotPasswordResponseDto(
        data: 'success',
        message: 'Password reset email sent',
        errorCode: '',
        isSuccess: true,
      );

      final result = dto.toJson();

      expect(result['data'], 'success');
      expect(result['message'], 'Password reset email sent');
      expect(result['errorCode'], '');
      expect(result['isSuccess'], true);
    });

    test('should convert ForgotPasswordResponseDto to ForgetPasswordEntity correctly', () {
      final dto = ForgotPasswordResponseDto(
        data: 'success',
        message: 'Password reset email sent',
        errorCode: '',
        isSuccess: true,
      );

      final result = dto.toDomain();

      expect(result, isA<ForgetPasswordEntity>());
      expect(result.isSuccess, true);
      expect(result.message, 'Password reset email sent');
    });
  });
}