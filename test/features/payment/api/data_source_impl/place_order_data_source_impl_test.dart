import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/payment/api/data_source_impl/place_order_data_source_impl.dart';
import 'package:flower_app/features/payment/data/model/request/place_order_request.dart';
import 'package:flower_app/features/payment/data/model/response/place_order_dto.dart';
import 'package:flower_app/features/payment/data/model/response/place_order_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mocks.mocks.dart';

void main() {
  late MockPaymentApiClient apiClient;
  late PlaceOrderDataSourceImpl dataSource;

  final request = PlaceOrderRequest(addressId: 'address-1');
  final dto = PlaceOrderDto(orderId: 'order-1', sessionUrl: 'https://pay');

  setUp(() {
    apiClient = MockPaymentApiClient();
    dataSource = PlaceOrderDataSourceImpl(apiClient);
  });

  group('PlaceOrderDataSourceImpl.palceOrder', () {
    test('wraps the response data in a success response', () async {
      // Arrange
      when(
        apiClient.placeOrder(request),
      ).thenAnswer((_) async => PlaceOrderResponse(data: dto));

      // Act
      final result = await dataSource.palceOrder(
        placeOrderRequest: request,
      );

      // Assert
      expect(result, isA<SuccessResponce<PlaceOrderDto>>());
      expect((result as SuccessResponce<PlaceOrderDto>).data, same(dto));
    });

    test('falls back to an empty dto when the response has no data', () async {
      // Arrange
      when(
        apiClient.placeOrder(request),
      ).thenAnswer((_) async => PlaceOrderResponse());

      // Act
      final result = await dataSource.palceOrder(
        placeOrderRequest: request,
      );

      // Assert
      final data = (result as SuccessResponce<PlaceOrderDto>).data;
      expect(data.orderId, isNull);
      expect(data.sessionUrl, isNull);
    });

    test('wraps a failure in an error response', () async {
      // Arrange
      when(apiClient.placeOrder(request)).thenThrow(Exception('boom'));

      // Act
      final result = await dataSource.palceOrder(
        placeOrderRequest: request,
      );

      // Assert
      expect(result, isA<ErrorResponce<PlaceOrderDto>>());
      final error = result as ErrorResponce<PlaceOrderDto>;
      expect(error.errorMessage, 'something went wrong, pls try again');
      expect(error.error, isA<Exception>());
    });
  });
}
