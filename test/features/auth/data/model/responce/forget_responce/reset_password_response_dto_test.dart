import 'package:flower_app/features/auth/data/model/responce/forget_responce/reset_password_response_dto.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResetPasswordResponseDto', () {
    test('should create ResetPasswordResponseDto from JSON correctly', () {
      final json = {
        'data': 'success',
        'message': 'Password reset successfully',
        'errorCode': '',
        'isSuccess': true,
      };

      final result = ResetPasswordResponseDto.fromJson(json);

      expect(result.data, 'success');
      expect(result.message, 'Password reset successfully');
      expect(result.errorCode, '');
      expect(result.isSuccess, true);
    });

    test('should convert ResetPasswordResponseDto to JSON correctly', () {
      final dto = ResetPasswordResponseDto(
        data: 'success',
        message: 'Password reset successfully',
        errorCode: '',
        isSuccess: true,
      );

      final result = dto.toJson();

      expect(result['data'], 'success');
      expect(result['message'], 'Password reset successfully');
      expect(result['errorCode'], '');
      expect(result['isSuccess'], true);
    });

    test(
      'should convert ResetPasswordResponseDto to ResetPassswordEntity correctly',
      () {
        final dto = ResetPasswordResponseDto(
          data: 'success',
          message: 'Password reset successfully',
          errorCode: '',
          isSuccess: true,
        );

        final result = dto.toDomain();

        expect(result, isA<ResetPassswordEntity>());
        expect(result.isSuccess, true);
        expect(result.message, 'Password reset successfully');
      },
    );
  });
}