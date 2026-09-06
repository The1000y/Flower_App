import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ForgetPasswordEntity Test', () {
    test('should create ForgetPasswordEntity correctly', () {
      final entity = ForgetPasswordEntity(isSuccess: true, message: "success");
      expect(entity.isSuccess, true);
      expect(entity.message, 'success');
    });

  });
}
