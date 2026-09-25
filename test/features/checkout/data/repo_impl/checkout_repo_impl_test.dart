import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/checkout/data/model/responce/checkout_details_dto.dart';
import 'package:flower_app/features/checkout/data/model/responce/estimation_time_dto.dart';
import 'package:flower_app/features/checkout/data/repo_impl/checkout_repo_impl.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flower_app/features/checkout/domain/entities/estimation_time_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/checkout_fixtures.dart';
import '../../mocks/mocks.mocks.dart';
import '../../mocks/test_dummies.dart';

void main() {
  registerCheckoutTestDummies();

  late MockRemoteDataSource mockRemoteDataSource;
  late CheckoutRepoImpl checkoutRepo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    checkoutRepo = CheckoutRepoImpl(mockRemoteDataSource);
  });

  group('CheckoutRepoImpl - getCheckoutDetails', () {
    test(
      'should return SuccessResponce with the mapped entity when the data source succeeds',
      () async {
        // Arrange
        when(mockRemoteDataSource.getCheckoutDetails()).thenAnswer(
          (_) async => SuccessResponce<CheckoutDetailsDto>(
            CheckoutFixtures.tCheckoutDetailsDto,
          ),
        );

        // Act
        final result = await checkoutRepo.getCheckoutDetails();

        // Assert
        expect(result, isA<SuccessResponce<CheckoutDetailsEntity>>());
        final data = (result as SuccessResponce<CheckoutDetailsEntity>).data;
        expect(data.subtotal, 200);
        expect(data.deliveryFee, 30);
        expect(data.total, 230);
        expect(data.estimatedDeliveryAt, CheckoutFixtures.tEstimatedDeliveryAt);
        expect(data.isGift, isFalse);
        expect(data.giftRecipientName, 'Mona Ahmed');
        expect(data.giftRecipientPhone, '01012345678');
        verify(mockRemoteDataSource.getCheckoutDetails()).called(1);
      },
    );

    test('should map the payment methods into entities', () async {
      // Arrange
      when(mockRemoteDataSource.getCheckoutDetails()).thenAnswer(
        (_) async => SuccessResponce<CheckoutDetailsDto>(
          CheckoutFixtures.tCheckoutDetailsDto,
        ),
      );

      // Act
      final result = await checkoutRepo.getCheckoutDetails();

      // Assert
      final data = (result as SuccessResponce<CheckoutDetailsEntity>).data;
      expect(data.paymentMethods.length, 2);
      expect(data.paymentMethods.first.method, CheckoutFixtures.tCod);
      expect(data.paymentMethods.first.gateways, ['cash']);
      expect(data.paymentMethods.last.method, CheckoutFixtures.tCard);
    });

    test(
      'should return zeroed defaults when the data source dto is empty',
      () async {
        // Arrange
        when(mockRemoteDataSource.getCheckoutDetails()).thenAnswer(
          (_) async => SuccessResponce<CheckoutDetailsDto>(
            CheckoutFixtures.tEmptyCheckoutDetailsDto,
          ),
        );

        // Act
        final result = await checkoutRepo.getCheckoutDetails();

        // Assert
        final data = (result as SuccessResponce<CheckoutDetailsEntity>).data;
        expect(data.subtotal, 0);
        expect(data.deliveryFee, 0);
        expect(data.total, 0);
        expect(data.estimatedDeliveryAt, isEmpty);
        expect(data.paymentMethods, isEmpty);
        expect(data.isGift, isFalse);
      },
    );

    test('should return ErrorResponce when the data source fails', () async {
      // Arrange
      final exception = Exception('Failed to get checkout details');
      when(
        mockRemoteDataSource.getCheckoutDetails(),
      ).thenAnswer((_) async => ErrorResponce<CheckoutDetailsDto>(exception));

      // Act
      final result = await checkoutRepo.getCheckoutDetails();

      // Assert
      expect(result, isA<ErrorResponce<CheckoutDetailsEntity>>());
      final error = result as ErrorResponce<CheckoutDetailsEntity>;
      expect(error.error, same(exception));
      expect(error.errorMessage, isNotEmpty);
      verify(mockRemoteDataSource.getCheckoutDetails()).called(1);
    });

    test(
      'should propagate the data source error without calling the estimation time',
      () async {
        // Arrange
        when(mockRemoteDataSource.getCheckoutDetails()).thenAnswer(
          (_) async => ErrorResponce<CheckoutDetailsDto>(Exception('boom')),
        );

        // Act
        await checkoutRepo.getCheckoutDetails();

        // Assert
        verifyNever(
          mockRemoteDataSource.getEstimationTime(
            addressId: CheckoutFixtures.tAddressId,
          ),
        );
      },
    );
  });

  group('CheckoutRepoImpl - getEstimationTime', () {
    test(
      'should return SuccessResponce with the mapped entity when the data source succeeds',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getEstimationTime(
            addressId: CheckoutFixtures.tAddressId,
          ),
        ).thenAnswer(
          (_) async => SuccessResponce<EstimationTimeDto>(
            CheckoutFixtures.tEstimationTimeDto,
          ),
        );

        // Act
        final result = await checkoutRepo.getEstimationTime(
          CheckoutFixtures.tAddressId,
        );

        // Assert
        expect(result, isA<SuccessResponce<EstimationTimeEntity>>());
        final data = (result as SuccessResponce<EstimationTimeEntity>).data;
        expect(data.estimatedDeliveryAt, CheckoutFixtures.tEstimatedDeliveryAt);
        verify(
          mockRemoteDataSource.getEstimationTime(
            addressId: CheckoutFixtures.tAddressId,
          ),
        ).called(1);
      },
    );

    test(
      'should return an empty estimated time when the data source dto is empty',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getEstimationTime(
            addressId: CheckoutFixtures.tAddressId,
          ),
        ).thenAnswer(
          (_) async => SuccessResponce<EstimationTimeDto>(
            CheckoutFixtures.tEmptyEstimationTimeDto,
          ),
        );

        // Act
        final result = await checkoutRepo.getEstimationTime(
          CheckoutFixtures.tAddressId,
        );

        // Assert
        final data = (result as SuccessResponce<EstimationTimeEntity>).data;
        expect(data.estimatedDeliveryAt, isEmpty);
      },
    );

    test('should return ErrorResponce when the data source fails', () async {
      // Arrange
      final exception = Exception('Failed to get estimation time');
      when(
        mockRemoteDataSource.getEstimationTime(
          addressId: CheckoutFixtures.tAddressId,
        ),
      ).thenAnswer((_) async => ErrorResponce<EstimationTimeDto>(exception));

      // Act
      final result = await checkoutRepo.getEstimationTime(
        CheckoutFixtures.tAddressId,
      );

      // Assert
      expect(result, isA<ErrorResponce<EstimationTimeEntity>>());
      expect(
        (result as ErrorResponce<EstimationTimeEntity>).error,
        same(exception),
      );
    });

    test('should forward the addressId to the data source', () async {
      // Arrange
      when(
        mockRemoteDataSource.getEstimationTime(addressId: 'another-address'),
      ).thenAnswer(
        (_) async => SuccessResponce<EstimationTimeDto>(
          CheckoutFixtures.tEstimationTimeDto,
        ),
      );

      // Act
      await checkoutRepo.getEstimationTime('another-address');

      // Assert
      verify(
        mockRemoteDataSource.getEstimationTime(addressId: 'another-address'),
      ).called(1);
    });
  });
}
