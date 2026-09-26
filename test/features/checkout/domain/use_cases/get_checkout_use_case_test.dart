import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flower_app/features/checkout/domain/use_cases/get_checkout_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/checkout_fixtures.dart';
import '../../mocks/mocks.mocks.dart';
import '../../mocks/test_dummies.dart';

void main() {
  registerCheckoutTestDummies();

  late MockCheckoutRepo mockCheckoutRepo;
  late GetCheckoutUseCase getCheckoutUseCase;

  setUp(() {
    mockCheckoutRepo = MockCheckoutRepo();
    getCheckoutUseCase = GetCheckoutUseCase(checkoutRepo: mockCheckoutRepo);
  });

  group('GetCheckoutUseCase', () {
    test(
      'should return SuccessResponce when the repository returns SuccessResponce',
      () async {
        // Arrange
        final response = SuccessResponce<CheckoutDetailsEntity>(
          CheckoutFixtures.tCheckoutDetailsEntity,
        );
        when(
          mockCheckoutRepo.getCheckoutDetails(),
        ).thenAnswer((_) async => response);

        // Act
        final result = await getCheckoutUseCase();

        // Assert
        expect(result, same(response));
        expect(result, isA<SuccessResponce<CheckoutDetailsEntity>>());
        final success = result as SuccessResponce<CheckoutDetailsEntity>;
        expect(success.data, CheckoutFixtures.tCheckoutDetailsEntity);
        expect(success.data.total, 230);
        verify(mockCheckoutRepo.getCheckoutDetails()).called(1);
      },
    );

    test(
      'should return ErrorResponce when the repository returns ErrorResponce',
      () async {
        // Arrange
        final exception = Exception('Failed to get checkout details');
        final response = ErrorResponce<CheckoutDetailsEntity>(exception);
        when(
          mockCheckoutRepo.getCheckoutDetails(),
        ).thenAnswer((_) async => response);

        // Act
        final result = await getCheckoutUseCase();

        // Assert
        expect(result, same(response));
        expect(result, isA<ErrorResponce<CheckoutDetailsEntity>>());
        final error = result as ErrorResponce<CheckoutDetailsEntity>;
        expect(error.error, same(exception));
        expect(error.errorMessage, isNotEmpty);
        verify(mockCheckoutRepo.getCheckoutDetails()).called(1);
      },
    );

    test(
      'should forward the repository call without any transformation',
      () async {
        // Arrange
        when(mockCheckoutRepo.getCheckoutDetails()).thenAnswer(
          (_) async => ErrorResponce<CheckoutDetailsEntity>(Exception('boom')),
        );

        // Act
        await getCheckoutUseCase();

        // Assert
        verify(mockCheckoutRepo.getCheckoutDetails()).called(1);
        verifyNoMoreInteractions(mockCheckoutRepo);
      },
    );
  });
}
