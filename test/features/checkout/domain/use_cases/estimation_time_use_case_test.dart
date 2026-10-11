import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/checkout/domain/entities/estimation_time_entity.dart';
import 'package:flower_app/features/checkout/domain/use_cases/estimation_time_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/checkout_fixtures.dart';
import '../../mocks/mocks.mocks.dart';
import '../../mocks/test_dummies.dart';

void main() {
  registerCheckoutTestDummies();

  late MockCheckoutRepo mockCheckoutRepo;
  late EstimationTimeUseCase estimationTimeUseCase;

  setUp(() {
    mockCheckoutRepo = MockCheckoutRepo();
    estimationTimeUseCase = EstimationTimeUseCase(mockCheckoutRepo);
  });

  group('EstimationTimeUseCase', () {
    test(
      'should return SuccessResponce when the repository returns SuccessResponce',
      () async {
        // Arrange
        final response = SuccessResponce<EstimationTimeEntity>(
          CheckoutFixtures.tEstimationTimeEntity,
        );
        when(
          mockCheckoutRepo.getEstimationTime(CheckoutFixtures.tAddressId),
        ).thenAnswer((_) async => response);

        // Act
        final result = await estimationTimeUseCase(
          addressId: CheckoutFixtures.tAddressId,
        );

        // Assert
        expect(result, same(response));
        expect(result, isA<SuccessResponce<EstimationTimeEntity>>());
        final success = result as SuccessResponce<EstimationTimeEntity>;
        expect(success.data, CheckoutFixtures.tEstimationTimeEntity);
        verify(
          mockCheckoutRepo.getEstimationTime(CheckoutFixtures.tAddressId),
        ).called(1);
      },
    );

    test(
      'should return ErrorResponce when the repository returns ErrorResponce',
      () async {
        // Arrange
        final exception = Exception('Failed to get estimation time');
        final response = ErrorResponce<EstimationTimeEntity>(exception);
        when(
          mockCheckoutRepo.getEstimationTime(CheckoutFixtures.tAddressId),
        ).thenAnswer((_) async => response);

        // Act
        final result = await estimationTimeUseCase(
          addressId: CheckoutFixtures.tAddressId,
        );

        // Assert
        expect(result, same(response));
        expect(result, isA<ErrorResponce<EstimationTimeEntity>>());
        final error = result as ErrorResponce<EstimationTimeEntity>;
        expect(error.error, same(exception));
        expect(error.errorMessage, isNotEmpty);
      },
    );

    test('should pass the addressId straight to the repository', () async {
      // Arrange
      when(mockCheckoutRepo.getEstimationTime('another-address')).thenAnswer(
        (_) async => SuccessResponce<EstimationTimeEntity>(
          CheckoutFixtures.tEstimationTimeEntity,
        ),
      );

      // Act
      await estimationTimeUseCase(addressId: 'another-address');

      // Assert
      verify(mockCheckoutRepo.getEstimationTime('another-address')).called(1);
      verifyNoMoreInteractions(mockCheckoutRepo);
    });
  });
}
