import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:flower_app/features/search/data/repo_impl/search_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_repo_impl_test.mocks.dart';

@GenerateMocks([CommerceRepo])
void main() {
  provideDummy<BaseResponce<List<ProductEntity>>>(
    SuccessResponce<List<ProductEntity>>(const []),
  );

  late MockCommerceRepo mockCommerceRepo;
  late SearchRepoImpl searchRepoImpl;

  setUp(() {
    mockCommerceRepo = MockCommerceRepo();
    searchRepoImpl = SearchRepoImpl(mockCommerceRepo);
  });

  final tProducts = [
    ProductEntity(
      id: 1,
      name: 'Red Roses Bouquet',
      imageUrl: 'https://example.com/rose.png',
      currency: 'EGP',
      price: 600,
      status: 'InStock',
    ),
    ProductEntity(
      id: 2,
      name: 'White Tulip Arrangement',
      imageUrl: 'https://example.com/tulip.png',
      currency: 'EGP',
      price: 500,
      status: 'InStock',
    ),
  ];

  group('SearchRepoImpl', () {
    test('should filter products case-insensitively when CommerceRepo.getProducts succeeds', () async {
      // Arrange
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => SuccessResponce<List<ProductEntity>>(tProducts));

      // Act
      final result = await searchRepoImpl.searchProduct('rose');

      // Assert
      expect(result, isA<SuccessResponce<List<ProductEntity>>>());
      final successResult = result as SuccessResponce<List<ProductEntity>>;
      expect(successResult.data.length, equals(1));
      expect(successResult.data.first.name, equals('Red Roses Bouquet'));
      verify(mockCommerceRepo.getProducts()).called(1);
    });

    test('should return empty list when no products match query', () async {
      // Arrange
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => SuccessResponce<List<ProductEntity>>(tProducts));

      // Act
      final result = await searchRepoImpl.searchProduct('sunflower');

      // Assert
      expect(result, isA<SuccessResponce<List<ProductEntity>>>());
      final successResult = result as SuccessResponce<List<ProductEntity>>;
      expect(successResult.data, isEmpty);
      verify(mockCommerceRepo.getProducts()).called(1);
    });

    test('should return ErrorResponce when CommerceRepo.getProducts fails', () async {
      // Arrange
      final tError = ErrorResponce<List<ProductEntity>>(Exception('Failed to fetch products'));
      when(mockCommerceRepo.getProducts()).thenAnswer((_) async => tError);

      // Act
      final result = await searchRepoImpl.searchProduct('rose');

      // Assert
      expect(result, isA<ErrorResponce<List<ProductEntity>>>());
      verify(mockCommerceRepo.getProducts()).called(1);
    });
  });
}
