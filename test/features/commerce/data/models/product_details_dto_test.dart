import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_details_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details/product_details_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductDetailsDto', () {
    final tJson = {
      'id': 1,
      'name': 'Test Product',
      'imageUrl': 'url',
      'currency': 'EGP',
      'price': 100.0,
      'originalPrice': 120.0,
      'discountPercentage': 16.6,
      'status': 'InStock',
      'images': ['img1', 'img2'],
      'description': 'desc',
      'includes': [
        {'name': 'item1', 'quantity': 1}
      ],
      'categoryId': 1,
      'occasionIds': [1, 2]
    };

    test('fromJson should return a valid DTO', () {
      final result = ProductDetailsDto.fromJson(tJson);
      expect(result.id, 1);
      expect(result.name, 'Test Product');
      expect(result.includes.length, 1);
      expect(result.includes[0].name, 'item1');
    });

    test('toDomain should return a valid Entity', () {
      final dto = ProductDetailsDto.fromJson(tJson);
      final result = dto.toDomain();

      expect(result, isA<ProductDetailsEntity>());
      expect(result.id, dto.id);
      expect(result.name, dto.name);
      expect(result.includes.length, dto.includes.length);
    });
  });
}
