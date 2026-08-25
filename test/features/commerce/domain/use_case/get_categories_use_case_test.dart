import 'package:flutter_test/flutter_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_categories_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/commerce_fixtures.dart';
import '../../mocks/mocks.mocks.dart';
import '../../mocks/test_dummies.dart';

void main() {
  registerCommerceTestDummies();

  late MockCommerceRepo mockCommerceRepo;
  late GetCategoriesUseCase useCase;

  setUp(() {
    mockCommerceRepo = MockCommerceRepo();
    useCase = GetCategoriesUseCase(commerceRepo: mockCommerceRepo);
  });

  group('GetCategoriesUseCase', () {
    final tSuccess =
        SuccessResponce<List<CategoryEntity>>(CommerceFixtures.tCategories);

    test(
      'returns SuccessResponce with categories when repository call succeeds',
      () async {
        // Arrange
        when(mockCommerceRepo.getCategories()).thenAnswer((_) async => tSuccess);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, isA<SuccessResponce<List<CategoryEntity>>>());
        expect(
          (result as SuccessResponce<List<CategoryEntity>>).data,
          equals(CommerceFixtures.tCategories),
        );
        verify(mockCommerceRepo.getCategories()).called(1);
        verifyNoMoreInteractions(mockCommerceRepo);
      },
    );

    test(
      'returns ErrorResponce with message when repository call fails',
      () async {
        // Arrange
        final tError =
            ErrorResponce<List<CategoryEntity>>(Exception('server error'));
        when(mockCommerceRepo.getCategories()).thenAnswer((_) async => tError);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, isA<ErrorResponce<List<CategoryEntity>>>());
        expect(
          (result as ErrorResponce<List<CategoryEntity>>).errorMessage,
          tError.errorMessage,
        );
        verify(mockCommerceRepo.getCategories()).called(1);
        verifyNoMoreInteractions(mockCommerceRepo);
      },
    );
  });
}
