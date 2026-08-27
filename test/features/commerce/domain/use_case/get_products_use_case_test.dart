import 'package:flower_app/config/base/base_responce.dart';
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

  test('should call getProducts on repository with occasionId and page and return SuccessResponce', () async {
    when(() => mockCommerceRepo.getProducts(1, page: 1))
        .thenAnswer((_) async => SuccessResponce<PaginatedProducts>(tPaginatedProducts));

    final result = await getProductsUseCase.execute(1, page: 1);

    expect(result, isA<SuccessResponce<PaginatedProducts>>());
    expect((result as SuccessResponce<PaginatedProducts>).data, tPaginatedProducts);
    verify(() => mockCommerceRepo.getProducts(1, page: 1)).called(1);
    verifyNoMoreInteractions(mockCommerceRepo);
  });

  test('should propagate ErrorResponce when repository fails', () async {
    final exception = Exception('Failed to get products');
    when(() => mockCommerceRepo.getProducts(1, page: 1))
        .thenAnswer((_) async => ErrorResponce<PaginatedProducts>(exception));

    final result = await getProductsUseCase.execute(1, page: 1);

    expect(result, isA<ErrorResponce<PaginatedProducts>>());
    verify(() => mockCommerceRepo.getProducts(1, page: 1)).called(1);
    verifyNoMoreInteractions(mockCommerceRepo);
  });
}