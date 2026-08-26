import 'package:flower_app/features/commerce/domain/use_case/get_product_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';

class MockCommerceRepo extends Mock implements CommerceRepo {}

void main() {
  late MockCommerceRepo mockCommerceRepo;
  late GetProductUseCase getProductUseCase;

  setUp(() {
    mockCommerceRepo = MockCommerceRepo();
    getProductUseCase = GetProductUseCase(mockCommerceRepo);
  });

  group('GetProductUseCase', () {
    test(
      'should return SuccessResponce when repository returns SuccessResponce',
      () async {
        final products = <ProductEntity>[
          ProductEntity(
            id: 1,
            name: 'Red Rose',
            imageUrl: 'https://example.com/rose.png',
            currency: 'EGP',
            price: 250,
            originalPrice: 300,
            discountPercentage: 16.67,
            status: 'Available',
          ),
        ];

        final response = SuccessResponce<List<ProductEntity>>(products);

        when(
          () => mockCommerceRepo.getProducts(),
        ).thenAnswer((_) async => response);

        final result = await getProductUseCase();

        expect(result, same(response));
        expect(result, isA<SuccessResponce<List<ProductEntity>>>());

        final success = result as SuccessResponce<List<ProductEntity>>;

        expect(success.data, products);
        expect(success.data.length, 1);
        expect(success.data.first.id, 1);
        expect(success.data.first.name, 'Red Rose');

        verify(
          () => mockCommerceRepo.getProducts(),
        ).called(1);
      },
    );

    test(
      'should return ErrorResponce when repository returns ErrorResponce',
      () async {
        final exception = Exception('Failed to get products');

        final response = ErrorResponce<List<ProductEntity>>(
          exception,
        );

        when(
          () => mockCommerceRepo.getProducts(),
        ).thenAnswer((_) async => response);

        final result = await getProductUseCase();

        expect(result, same(response));
        expect(result, isA<ErrorResponce<List<ProductEntity>>>());

        final error = result as ErrorResponce<List<ProductEntity>>;

        expect(error.error, same(exception));

        verify(
          () => mockCommerceRepo.getProducts(),
        ).called(1);
      },
    );
  });
}
