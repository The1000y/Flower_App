import 'package:flutter_test/flutter_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_best_seller_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/commerce_fixtures.dart';
import '../../mocks/mocks.mocks.dart';
import '../../mocks/test_dummies.dart';

void main() {
  registerCommerceTestDummies();

  late MockCommerceRepo mockCommerceRepo;
  late GetBestSellerUseCase useCase;

  setUp(() {
    mockCommerceRepo = MockCommerceRepo();
    useCase = GetBestSellerUseCase(commerceRepo: mockCommerceRepo);
  });

  group('GetBestSellerUseCase', () {
    test(
      'returns SuccessResponce with best sellers when repository call succeeds',
      () async {
        // Arrange
        final tSuccess =
            SuccessResponce<List<BestSellerEntity>>(CommerceFixtures.tBestSellers);
        when(mockCommerceRepo.getBestSeller()).thenAnswer((_) async => tSuccess);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, isA<SuccessResponce<List<BestSellerEntity>>>());
        expect(
          (result as SuccessResponce<List<BestSellerEntity>>).data,
          equals(CommerceFixtures.tBestSellers),
        );
        verify(mockCommerceRepo.getBestSeller()).called(1);
        verifyNoMoreInteractions(mockCommerceRepo);
      },
    );

    test(
      'returns ErrorResponce with message when repository call fails',
      () async {
        // Arrange
        final tError =
            ErrorResponce<List<BestSellerEntity>>(Exception('network error'));
        when(mockCommerceRepo.getBestSeller()).thenAnswer((_) async => tError);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, isA<ErrorResponce<List<BestSellerEntity>>>());
        expect(
          (result as ErrorResponce<List<BestSellerEntity>>).errorMessage,
          tError.errorMessage,
        );
        verify(mockCommerceRepo.getBestSeller()).called(1);
        verifyNoMoreInteractions(mockCommerceRepo);
      },
    );
  });
}
