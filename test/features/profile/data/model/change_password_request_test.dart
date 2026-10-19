import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChangePasswordRequest', () {
    test('should instantiate correctly and convert to and from JSON', () {
      final request = ChangePasswordRequest(
        currentPassword: 'OldPassword123',
        newPassword: 'NewPassword123',
        confirmNewPassword: 'NewPassword123',
      );

      expect(request.currentPassword, 'OldPassword123');
      expect(request.newPassword, 'NewPassword123');
      expect(request.confirmNewPassword, 'NewPassword123');

      final jsonMap = request.toJson();
      expect(jsonMap['currentPassword'], 'OldPassword123');
      expect(jsonMap['newPassword'], 'NewPassword123');
      expect(jsonMap['confirmNewPassword'], 'NewPassword123');

      final requestFromJson = ChangePasswordRequest.fromJson(jsonMap);
      expect(requestFromJson.currentPassword, 'OldPassword123');
      expect(requestFromJson.newPassword, 'NewPassword123');
      expect(requestFromJson.confirmNewPassword, 'NewPassword123');
    });
  });
}
