import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChangePasswordEntity Test', () {
    test('should create ChangePasswordEntity correctly', () {
      const entity = ChangePasswordEntity(
        data: true,
        isSuccess: true,
        message: 'Password changed successfully',
        errorCode: 200,
      );

      expect(entity.data, true);
      expect(entity.isSuccess, true);
      expect(entity.message, 'Password changed successfully');
      expect(entity.errorCode, 200);
    });

    test('should support value equality via Equatable', () {
      const entity1 = ChangePasswordEntity(
        data: true,
        isSuccess: true,
        message: 'Success',
        errorCode: 200,
      );
      const entity2 = ChangePasswordEntity(
        data: true,
        isSuccess: true,
        message: 'Success',
        errorCode: 200,
      );

      expect(entity1, equals(entity2));
    });
  });
}
