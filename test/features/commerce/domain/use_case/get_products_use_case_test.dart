import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_products_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommerceRepo extends Mock implements CommerceRepo {}

void main() {
  late MockCommerceRepo mockCommerceRepo;
  late GetProductsUseCase getProductsUseCase;

  setUp(() {
    mockCommerceRepo = MockCommerceRepo();
    getProductsUseCase = GetProductsUseCase(mockCommerceRepo);
  });

  test('should call getProducts on repository with occasionId and page and return paginated products', () async {
    // Arrange
    final tPaginatedProducts = PaginatedProducts(
      items: [],
      pagination: PaginationEntity(
        page: 1,
        pageSize: 10,
        totalCount: 0,
        totalPages: 0,
        hasNextPage: false,
        hasPreviousPage: false,
      ),
    );
    when(() => mockCommerceRepo.getProducts(1, page: 1)).thenAnswer((_) async => tPaginatedProducts);

    // Act
    final result = await getProductsUseCase.execute(1, page: 1);

    // Assert
    expect(result, tPaginatedProducts);
    verify(() => mockCommerceRepo.getProducts(1, page: 1)).called(1);
    verifyNoMoreInteractions(mockCommerceRepo);
  });
}
