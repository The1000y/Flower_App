import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/search/domain/repo/search_repo.dart';
import 'package:flower_app/features/search/domain/usecases/search_products_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_products_use_case_test.mocks.dart';

@GenerateMocks([SearchRepo])
void main() {
  provideDummy<BaseResponce<List<ProductEntity>>>(
    SuccessResponce<List<ProductEntity>>(const []),
  );

  late MockSearchRepo mockSearchRepo;
  late SearchProductsUseCase useCase;

  setUp(() {
    mockSearchRepo = MockSearchRepo();
    useCase = SearchProductsUseCase(mockSearchRepo);
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
  ];

  group('SearchProductsUseCase', () {
    test('should return SuccessResponce with matching products when search repo succeeds', () async {
      // Arrange
      final tSuccess = SuccessResponce<List<ProductEntity>>(tProducts);
      when(mockSearchRepo.searchProduct('rose')).thenAnswer((_) async => tSuccess);

      // Act
      final result = await useCase.call('rose');

      // Assert
      expect(result, isA<SuccessResponce<List<ProductEntity>>>());
      expect((result as SuccessResponce<List<ProductEntity>>).data, equals(tProducts));
      verify(mockSearchRepo.searchProduct('rose')).called(1);
      verifyNoMoreInteractions(mockSearchRepo);
    });

    test('should return ErrorResponce when search repo fails', () async {
      // Arrange
      final tError = ErrorResponce<List<ProductEntity>>(Exception('Search failed'));
      when(mockSearchRepo.searchProduct('rose')).thenAnswer((_) async => tError);

      // Act
      final result = await useCase.call('rose');

      // Assert
      expect(result, isA<ErrorResponce<List<ProductEntity>>>());
      expect((result as ErrorResponce<List<ProductEntity>>).errorMessage, equals(tError.errorMessage));
      verify(mockSearchRepo.searchProduct('rose')).called(1);
      verifyNoMoreInteractions(mockSearchRepo);
    });
  });
}
