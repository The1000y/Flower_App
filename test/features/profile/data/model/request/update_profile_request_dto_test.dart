import 'package:flower_app/features/profile/data/model/request/update_profile_request_dto.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UpdateProfileRequestDto', () {
    test('fromDomain maps values correctly (without image file check)', () {
      final entity = const ProfileEntity(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phoneNumber: '01000000000',
        gender: 'Male',
        photoUrl: 'invalid/path/that/does/not/exist.jpg', 
      );

      final dto = UpdateProfileRequestDto.fromDomain(entity);
      expect(dto.fullName, 'John Doe');
      expect(dto.email, 'john@example.com');
      expect(dto.phone, '01000000000');
      expect(dto.gender, 'Male');
      expect(dto.photo, isNull);
    });

    test('toJson produces correct map', () {
      final dto = UpdateProfileRequestDto(
        fullName: 'Jane Doe',
        email: 'jane@example.com',
        phone: '01000000001',
        gender: 'Female',
      );

      final json = dto.toJson();
      expect(json['FullName'], 'Jane Doe');
      expect(json['Email'], 'jane@example.com');
      expect(json['Phone'], '01000000001');
      expect(json['Gender'], 'Female');
      expect(json.containsKey('photo'), false); // photo is excluded
      expect(json.containsKey('Photo'), false);
    });
  });
}
