import 'package:flower_app/features/addresses/data/model/%20response/address_dto.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddressDto', () {
    final json = {
      'id': 'dummy-id-456',
      'recipientName': 'Mona Ahmed',
      'recipientPhone': '01012345678',
      'addressLine': '2XVP+XC',
      'city': 'Cairo',
      'area': 'Sheikh Zayed',
      'lat': 30.0131,
      'lng': 31.2089,
      'label': 'Work',
      'isDefault': true,
      'storeId': 'store-456',
      'isServiceable': true,
      'createdAt': '2024-02-10T09:15:00.000Z',
    };

    final dto = AddressDto(
      id: 'dummy-id-456',
      recipientName: 'Mona Ahmed',
      recipientPhone: '01012345678',
      addressLine: '2XVP+XC',
      city: 'Cairo',
      area: 'Sheikh Zayed',
      lat: 30.0131,
      lng: 31.2089,
      label: 'Work',
      isDefault: true,
      storeId: 'store-456',
     isServiceable: true,
    );

    test('should create AddressDto from JSON correctly', () {
      final result = AddressDto.fromJson(json);

      expect(result.id, 'dummy-id-456');
      expect(result.recipientName, 'Mona Ahmed');
      expect(result.isDefault, true);
    });

    test('should convert AddressDto to JSON correctly', () {
      final result = dto.toJson();

      expect(result['id'], 'dummy-id-456');
      expect(result['recipientName'], 'Mona Ahmed');
      expect(result['isDefault'], true);
    });

    test('should convert AddressDto to AddressEntity correctly', () {
      final result = dto.toDomain();

      expect(result, isA<AddressEntity>());
      expect(result.id, 'dummy-id-456');
      expect(result.isDefault, true);
    });
  });
}
