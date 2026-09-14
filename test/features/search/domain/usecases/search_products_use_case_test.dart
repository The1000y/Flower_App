import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:flower_app/features/search/domain/usecases/search_products_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_products_use_case_test.mocks.dart';

@GenerateMocks([CommerceRepo])
void main() {
  provideDummy<BaseResponce<List<ProductEntity>>>(
    SuccessResponce<List<ProductEntity>>(const []),
  );

  late MockCommerceRepo mockCommerceRepo;
  late SearchProductsUseCase useCase;

  setUp(() {
    mockCommerceRepo = MockCommerceRepo();
    useCase = SearchProductsUseCase(mockCommerceRepo);
  });

  final tProducts = [
    const ProductEntity(
      id: 1,
      name: 'Red Roses Bouquet',
      imageUrl: 'https://example.com/rose.png',
      currency: 'EGP',
      price: 600,
      status: 'InStock',
    ),
    const ProductEntity(
      id: 2,
      name: 'White Tulip Arrangement',
      imageUrl: 'https://example.com/tulip.png',
      currency: 'EGP',
      price: 500,
      status: 'InStock',
    ),
    const ProductEntity(
      id: 3,
      name: 'Rose Gold Vase',
      imageUrl: 'https://example.com/vase.png',
      currency: 'EGP',
      price: 350,
      status: 'InStock',
    ),
    const ProductEntity(
      id: 4,
      name: 'Birthday Cake',
      imageUrl: 'https://example.com/cake.png',
      currency: 'EGP',
      price: 200,
      status: 'InStock',
    ),
  ];

  group('SearchProductsUseCase', () {
    test('should return matching products when query matches by name', () async {
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => SuccessResponce<List<ProductEntity>>(tProducts));

      final result = await useCase.call('rose');

      expect(result, isA<SuccessResponce<List<ProductEntity>>>());
      final data = (result as SuccessResponce<List<ProductEntity>>).data;
      expect(data.length, equals(2));
      expect(data[0].name, equals('Red Roses Bouquet'));
      expect(data[1].name, equals('Rose Gold Vase'));
      verify(mockCommerceRepo.getProducts()).called(1);
    });

    test('should be case-insensitive when filtering products', () async {
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => SuccessResponce<List<ProductEntity>>(tProducts));

      final result = await useCase.call('TULIP');

      expect(result, isA<SuccessResponce<List<ProductEntity>>>());
      final data = (result as SuccessResponce<List<ProductEntity>>).data;
      expect(data.length, equals(1));
      expect(data.first.name, equals('White Tulip Arrangement'));
    });

    test('should match partial substrings in product name', () async {
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => SuccessResponce<List<ProductEntity>>(tProducts));

      final result = await useCase.call('Tul');

      expect(result, isA<SuccessResponce<List<ProductEntity>>>());
      final data = (result as SuccessResponce<List<ProductEntity>>).data;
      expect(data.length, equals(1));
      expect(data.first.name, equals('White Tulip Arrangement'));
    });

    test('should return empty list when no products match', () async {
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => SuccessResponce<List<ProductEntity>>(tProducts));

      final result = await useCase.call('sunflower');

      expect(result, isA<SuccessResponce<List<ProductEntity>>>());
      final data = (result as SuccessResponce<List<ProductEntity>>).data;
      expect(data, isEmpty);
    });

    test('should return all products when query matches every name', () async {
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => SuccessResponce<List<ProductEntity>>(tProducts));

      final result = await useCase.call('e');

      expect(result, isA<SuccessResponce<List<ProductEntity>>>());
      final data = (result as SuccessResponce<List<ProductEntity>>).data;
      expect(data.length, equals(4));
    });

    test('should return ErrorResponce when CommerceRepo.getProducts fails', () async {
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => ErrorResponce<List<ProductEntity>>(Exception('Fetch failed')));

      final result = await useCase.call('rose');

      expect(result, isA<ErrorResponce<List<ProductEntity>>>());
      verify(mockCommerceRepo.getProducts()).called(1);
    });
  });
}
