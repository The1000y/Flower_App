import 'package:dio/dio.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/checkout/api/data_source_impl/remote_data_source_impl.dart';
import 'package:flower_app/features/checkout/data/model/responce/checkout_details_dto.dart';
import 'package:flower_app/features/checkout/data/model/responce/checkout_responce.dart';
import 'package:flower_app/features/checkout/data/model/responce/estimation_time_dto.dart';
import 'package:flower_app/features/checkout/data/model/responce/estimation_time_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/checkout_fixtures.dart';
import '../../../mocks/mocks.mocks.dart';
import '../../../mocks/test_dummies.dart';

void main() {
  registerCheckoutTestDummies();

  late MockCheckoutApiClient mockCheckoutApiClient;
  late RemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockCheckoutApiClient = MockCheckoutApiClient();
    remoteDataSource = RemoteDataSourceImpl(mockCheckoutApiClient);
  });

  group('RemoteDataSourceImpl - getCheckoutDetails', () {
    test(
      'should return SuccessResponce with the dto when the api succeeds',
      () async {
        // Arrange
        when(
          mockCheckoutApiClient.getCheckoutDetails(),
        ).thenAnswer((_) async => CheckoutFixtures.tCheckoutResponce);

        // Act
        final result = await remoteDataSource.getCheckoutDetails();

        // Assert
        expect(result, isA<SuccessResponce<CheckoutDetailsDto>>());
        final data = (result as SuccessResponce<CheckoutDetailsDto>).data;
        expect(data.subtotal, 200);
        expect(data.total, 230);
        expect(data.paymentMethods!.length, 2);
        verify(mockCheckoutApiClient.getCheckoutDetails()).called(1);
      },
    );

    test(
      'should return an empty dto when the api returns a null data',
      () async {
        // Arrange
        when(mockCheckoutApiClient.getCheckoutDetails()).thenAnswer(
          (_) async => CheckoutResponce(success: true, message: 'Empty'),
        );

        // Act
        final result = await remoteDataSource.getCheckoutDetails();

        // Assert
        expect(result, isA<SuccessResponce<CheckoutDetailsDto>>());
        final data = (result as SuccessResponce<CheckoutDetailsDto>).data;
        expect(data.subtotal, isNull);
        expect(data.paymentMethods, isNull);
      },
    );

    test(
      'should return ErrorResponce when the api throws an Exception',
      () async {
        // Arrange
        when(
          mockCheckoutApiClient.getCheckoutDetails(),
        ).thenThrow(Exception('Fetch failed'));

        // Act
        final result = await remoteDataSource.getCheckoutDetails();

        // Assert
        expect(result, isA<ErrorResponce<CheckoutDetailsDto>>());
        final error = result as ErrorResponce<CheckoutDetailsDto>;
        expect(error.error, isA<Exception>());
        expect(error.errorMessage, isNotEmpty);
      },
    );

    test(
      'should return ErrorResponce when the api throws a DioException',
      () async {
        // Arrange
        when(mockCheckoutApiClient.getCheckoutDetails()).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/checkout'),
            type: DioExceptionType.connectionError,
          ),
        );

        // Act
        final result = await remoteDataSource.getCheckoutDetails();

        // Assert
        expect(result, isA<ErrorResponce<CheckoutDetailsDto>>());
        expect(
          (result as ErrorResponce<CheckoutDetailsDto>).errorMessage,
          'connectionError',
        );
      },
    );
  });

  group('RemoteDataSourceImpl - getEstimationTime', () {
    test(
      'should return SuccessResponce with the dto when the api succeeds',
      () async {
        // Arrange
        when(
          mockCheckoutApiClient.getEstimationTime(CheckoutFixtures.tAddressId),
        ).thenAnswer((_) async => CheckoutFixtures.tEstimationTimeResponse);

        // Act
        final result = await remoteDataSource.getEstimationTime(
          addressId: CheckoutFixtures.tAddressId,
        );

        // Assert
        expect(result, isA<SuccessResponce<EstimationTimeDto>>());
        final data = (result as SuccessResponce<EstimationTimeDto>).data;
        expect(data.estimatedDeliveryAt, CheckoutFixtures.tEstimatedDeliveryAt);
        verify(
          mockCheckoutApiClient.getEstimationTime(CheckoutFixtures.tAddressId),
        ).called(1);
      },
    );

    test(
      'should return an empty dto when the api returns a null data',
      () async {
        // Arrange
        when(
          mockCheckoutApiClient.getEstimationTime(CheckoutFixtures.tAddressId),
        ).thenAnswer((_) async => EstimationTimeResponse(success: true));

        // Act
        final result = await remoteDataSource.getEstimationTime(
          addressId: CheckoutFixtures.tAddressId,
        );

        // Assert
        expect(result, isA<SuccessResponce<EstimationTimeDto>>());
        final data = (result as SuccessResponce<EstimationTimeDto>).data;
        expect(data.estimatedDeliveryAt, isNull);
      },
    );

    test(
      'should return ErrorResponce when the api throws an Exception',
      () async {
        // Arrange
        when(
          mockCheckoutApiClient.getEstimationTime(CheckoutFixtures.tAddressId),
        ).thenThrow(Exception('Estimation failed'));

        // Act
        final result = await remoteDataSource.getEstimationTime(
          addressId: CheckoutFixtures.tAddressId,
        );

        // Assert
        expect(result, isA<ErrorResponce<EstimationTimeDto>>());
        expect(
          (result as ErrorResponce<EstimationTimeDto>).errorMessage,
          isNotEmpty,
        );
      },
    );

    test('should forward the addressId to the api client', () async {
      // Arrange
      when(
        mockCheckoutApiClient.getEstimationTime('another-address'),
      ).thenAnswer((_) async => CheckoutFixtures.tEstimationTimeResponse);

      // Act
      await remoteDataSource.getEstimationTime(addressId: 'another-address');

      // Assert
      verify(
        mockCheckoutApiClient.getEstimationTime('another-address'),
      ).called(1);
      verifyNever(mockCheckoutApiClient.getCheckoutDetails());
    });
  });
}
