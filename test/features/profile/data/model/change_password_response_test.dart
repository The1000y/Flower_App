import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChangePasswordResponse', () {
    test('should instantiate correctly, map to/from JSON, and map to entity via toEntity()', () {
      final response = ChangePasswordResponse(
        data: true,
        isSuccess: true,
        message: 'Password changed successfully',
        errorCode: 200,
      );

      expect(response.data, true);
      expect(response.isSuccess, true);
      expect(response.message, 'Password changed successfully');
      expect(response.errorCode, 200);

      final jsonMap = response.toJson();
      expect(jsonMap['data'], true);
      expect(jsonMap['isSuccess'], true);
      expect(jsonMap['message'], 'Password changed successfully');
      expect(jsonMap['errorCode'], 200);

      final responseFromJson = ChangePasswordResponse.fromJson(jsonMap);
      expect(responseFromJson.data, true);
      expect(responseFromJson.isSuccess, true);

      final entity = response.toEntity();
      expect(entity.data, true);
      expect(entity.isSuccess, true);
      expect(entity.message, 'Password changed successfully');
      expect(entity.errorCode, 200);
    });
  });
}
