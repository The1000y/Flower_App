import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/checkout/presentation/manager/checkout_payment_method.dart';
import 'package:flower_app/features/payment/data/model/request/place_order_request.dart';
import 'package:flower_app/features/payment/data/model/response/place_order_dto.dart';
import 'package:flower_app/features/payment/data/repo_impl/place_order_repo_impl.dart';
import 'package:flower_app/features/payment/domain/entities/param/place_order_param.dart';
import 'package:flower_app/features/payment/domain/entities/place_order_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mocks.mocks.dart';
import '../../mocks/test_dummies.dart';

void main() {
  late MockRemoteDataSource remoteDataSource;
  late PlaceOrderRepoImpl repo;

  final param = PlaceOrderParam(
    addressId: 'address-1',
    paymentMethod: CheckoutPaymentMethod.Card,
    isGift: true,
    giftRecipientName: 'Mona',
    giftRecipientPhone: '01012345678',
  );
  final dto = PlaceOrderDto(
    orderId: 'order-1',
    status: 'PendingPayment',
    sessionUrl: 'https://pay/session',
  );

  setUp(() {
    registerPaymentTestDummies();
    remoteDataSource = MockRemoteDataSource();
    repo = PlaceOrderRepoImpl(remoteDataSource: remoteDataSource);
  });

  group('PlaceOrderRepoImpl.palceOrder', () {
    test('maps a successful data source response onto the entity', () async {
      // Arrange
      when(
        remoteDataSource.palceOrder(placeOrderRequest: anyNamed('placeOrderRequest')),
      ).thenAnswer((_) async => SuccessResponce<PlaceOrderDto>(dto));

      // Act
      final result = await repo.palceOrder(placeOrderParam: param);

      // Assert
      expect(result, isA<SuccessResponce<PlaceOrderEntity>>());
      final entity = (result as SuccessResponce<PlaceOrderEntity>).data;
      expect(entity.orderId, 'order-1');
      expect(entity.status, 'PendingPayment');
      expect(entity.sessionUrl, 'https://pay/session');
      expect(entity.message, '');
    });

    test('forwards the param as a place order request', () async {
      // Arrange
      when(
        remoteDataSource.palceOrder(placeOrderRequest: anyNamed('placeOrderRequest')),
      ).thenAnswer((_) async => SuccessResponce<PlaceOrderDto>(dto));

      // Act
      await repo.palceOrder(placeOrderParam: param);

      // Assert
      final captured =
          verify(
            remoteDataSource.palceOrder(
              placeOrderRequest: captureAnyNamed('placeOrderRequest'),
            ),
          ).captured;
      final request = captured.single as PlaceOrderRequest;
      expect(request.addressId, 'address-1');
      expect(request.paymentMethod, 'Card');
      expect(request.paymentGateway, 'Paymob');
      expect(request.isGift, isTrue);
      expect(request.giftRecipientName, 'Mona');
      expect(request.giftRecipientPhone, '01012345678');
    });

    test('forwards the data source error unchanged', () async {
      // Arrange
      final failure = Exception('boom');
      when(
        remoteDataSource.palceOrder(placeOrderRequest: anyNamed('placeOrderRequest')),
      ).thenAnswer((_) async => ErrorResponce<PlaceOrderDto>(failure));

      // Act
      final result = await repo.palceOrder(placeOrderParam: param);

      // Assert
      expect(result, isA<ErrorResponce<PlaceOrderEntity>>());
      final error = result as ErrorResponce<PlaceOrderEntity>;
      expect(error.error, same(failure));
      expect(error.errorMessage, 'something went wrong, pls try again');
    });
  });
}
