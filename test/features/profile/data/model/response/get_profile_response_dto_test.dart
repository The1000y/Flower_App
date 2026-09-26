import 'package:flower_app/features/profile/data/model/response/get_profile_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetProfileResponseDto', () {
    test('fromJson assigns variables correctly', () {
      final json = {
        'fullName': 'John Doe',
        'email': 'john@example.com',
        'phone': '01000000000',
        'gender': 'Male',
        'photoUrl': 'http://image.com/img.jpg',
      };

      final dto = GetProfileResponseDto.fromJson(json);
      expect(dto.fullName, 'John Doe');
      expect(dto.email, 'john@example.com');
      expect(dto.phone, '01000000000');
      expect(dto.gender, 'Male');
      expect(dto.photoUrl, 'http://image.com/img.jpg');
    });

    test('toDomain maps values correctly', () {
      final dto = GetProfileResponseDto(
        fullName: 'Jane Doe',
        email: 'jane@example.com',
        phone: '01000000001',
        gender: 'Female',
        photoUrl: 'http://image.com/jane.jpg',
      );

      final domain = dto.toDomain();
      expect(domain.firstName, 'Jane');
      expect(domain.lastName, 'Doe');
      expect(domain.email, 'jane@example.com');
      expect(domain.phoneNumber, '01000000001');
      expect(domain.gender, 'Female');
      expect(domain.photoUrl, 'http://image.com/jane.jpg');
    });

    test('toDomain maps values correctly when fullName has no spaces', () {
      final dto = GetProfileResponseDto(
        fullName: 'Jane',
        email: 'jane@example.com',
        phone: '01000000001',
        gender: 'Female',
      );

      final domain = dto.toDomain();
      expect(domain.firstName, 'Jane');
      expect(domain.lastName, '');
    });

    test('toDomain maps values correctly with null values', () {
      final dto = GetProfileResponseDto();

      final domain = dto.toDomain();
      expect(domain.firstName, '');
      expect(domain.lastName, '');
      expect(domain.email, '');
      expect(domain.phoneNumber, '');
      expect(domain.gender, '');
      expect(domain.photoUrl, null);
    });
  });
}
