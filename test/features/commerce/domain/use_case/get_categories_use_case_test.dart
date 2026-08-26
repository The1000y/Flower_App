import 'package:flower_app/features/commerce/domain/use_case/get_categories_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';

class MockCommerceRepo extends Mock implements CommerceRepo {}

void main() {
  late MockCommerceRepo mockCommerceRepo;
  late GetCategoriesUseCase getCategoriesUseCase;

  setUp(() {
    mockCommerceRepo = MockCommerceRepo();
    getCategoriesUseCase = GetCategoriesUseCase(mockCommerceRepo);
  });

  group('GetCategoriesUseCase', () {
    test(
      'should return SuccessResponce when repository returns SuccessResponce',
      () async {
        // Arrange
        final categories = <CategoryEntity>[
          CategoryEntity(
            id: 1,
            name: 'Roses',
            iconUrl: 'https://example.com/rose.png',
          ),
        ];

        final response = SuccessResponce<List<CategoryEntity>>(
          categories,
        );

        when(
          () => mockCommerceRepo.getCategories(),
        ).thenAnswer((_) async => response);

        // Act
        final result = await getCategoriesUseCase();

        // Assert
        expect(result, same(response));

        expect(
          result,
          isA<SuccessResponce<List<CategoryEntity>>>(),
        );

        final success = result as SuccessResponce<List<CategoryEntity>>;

        expect(success.data, categories);
        expect(success.data.length, 1);
        expect(success.data.first.id, 1);
        expect(success.data.first.name, 'Roses');
        expect(
          success.data.first.iconUrl,
          'https://example.com/rose.png',
        );

        verify(
          () => mockCommerceRepo.getCategories(),
        ).called(1);
      },
    );

    test(
      'should return ErrorResponce when repository returns ErrorResponce',
      () async {
        // Arrange
        final exception = Exception('Failed to get categories');

        final response = ErrorResponce<List<CategoryEntity>>(
          exception,
        );

        when(
          () => mockCommerceRepo.getCategories(),
        ).thenAnswer((_) async => response);

        // Act
        final result = await getCategoriesUseCase();

        // Assert
        expect(result, same(response));

        expect(
          result,
          isA<ErrorResponce<List<CategoryEntity>>>(),
        );

        final error = result as ErrorResponce<List<CategoryEntity>>;

        expect(error.error, same(exception));

        verify(
          () => mockCommerceRepo.getCategories(),
        ).called(1);
      },
    );
  });
}