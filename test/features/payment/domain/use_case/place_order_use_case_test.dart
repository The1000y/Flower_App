import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/checkout/presentation/manager/checkout_payment_method.dart';
import 'package:flower_app/features/payment/domain/entities/param/place_order_param.dart';
import 'package:flower_app/features/payment/domain/entities/place_order_entity.dart';
import 'package:flower_app/features/payment/domain/use_case/place_order_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mocks.mocks.dart';
import '../../mocks/test_dummies.dart';

void main() {
  late MockPlaceOrderRepo repo;
  late PlaceOrderUseCase useCase;

  const param = PlaceOrderParam(
    addressId: 'address-1',
    paymentMethod: CheckoutPaymentMethod.COD,
  );
  const entity = PlaceOrderEntity(
    message: 'created',
    orderId: 'order-1',
    sessionUrl: 'https://pay/session',
  );

  setUp(() {
    registerPaymentTestDummies();
    repo = MockPlaceOrderRepo();
    useCase = PlaceOrderUseCase(placeOrderRepo: repo);
  });

  group('PlaceOrderUseCase.call', () {
    test('returns the repo response for the given param', () async {
      // Arrange
      when(repo.palceOrder(placeOrderParam: anyNamed('placeOrderParam')))
          .thenAnswer((_) async => SuccessResponce<PlaceOrderEntity>(entity));

      // Act
      final result = await useCase.call(param);

      // Assert
      expect(result, isA<SuccessResponce<PlaceOrderEntity>>());
      expect(
        (result as SuccessResponce<PlaceOrderEntity>).data,
        same(entity),
      );
      verify(repo.palceOrder(placeOrderParam: param)).called(1);
    });

    test('returns the repo error response unchanged', () async {
      // Arrange
      final failure = Exception('boom');
      when(repo.palceOrder(placeOrderParam: anyNamed('placeOrderParam')))
          .thenAnswer((_) async => ErrorResponce<PlaceOrderEntity>(failure));

      // Act
      final result = await useCase.call(param);

      // Assert
      expect(result, isA<ErrorResponce<PlaceOrderEntity>>());
      expect((result as ErrorResponce<PlaceOrderEntity>).error, same(failure));
    });
  });
}
