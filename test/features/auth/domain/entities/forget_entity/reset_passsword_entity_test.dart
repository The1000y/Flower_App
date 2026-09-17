import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResetPasswordEntity', () {
    test('should create ResetPasswordEntity correctly', () {
      final entity = ResetPassswordEntity(isSuccess: true, message: 'success');
      expect(entity.isSuccess, true);
      expect(entity.message, 'success');
    });
  });
}
