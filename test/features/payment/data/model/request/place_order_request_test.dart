import 'package:flower_app/features/checkout/presentation/manager/checkout_payment_method.dart';
import 'package:flower_app/features/payment/data/model/request/place_order_request.dart';
import 'package:flower_app/features/payment/domain/entities/param/place_order_param.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  PlaceOrderParam param({
    CheckoutPaymentMethod paymentMethod = CheckoutPaymentMethod.COD,
    bool isGift = false,
    String? giftRecipientName,
    String? giftRecipientPhone,
  }) => PlaceOrderParam(
    addressId: 'address-1',
    paymentMethod: paymentMethod,
    isGift: isGift,
    giftRecipientName: giftRecipientName,
    giftRecipientPhone: giftRecipientPhone,
  );

  group('PlaceOrderRequest.fromParam', () {
    test('maps a cash on delivery order', () {
      final request = PlaceOrderRequest.fromParam(param());

      expect(request.addressId, 'address-1');
      expect(request.paymentMethod, 'COD');
      expect(request.paymentGateway, isNull);
      expect(request.isGift, isFalse);
      expect(request.giftRecipientName, isNull);
      expect(request.giftRecipientPhone, isNull);
    });

    test('maps a card order onto the Paymob gateway', () {
      final request = PlaceOrderRequest.fromParam(
        param(paymentMethod: CheckoutPaymentMethod.Card),
      );

      expect(request.paymentMethod, 'Card');
      expect(request.paymentGateway, 'Paymob');
    });

    test('keeps the gift recipient of a gift order', () {
      final request = PlaceOrderRequest.fromParam(
        param(
          isGift: true,
          giftRecipientName: 'Mona',
          giftRecipientPhone: '01012345678',
        ),
      );

      expect(request.isGift, isTrue);
      expect(request.giftRecipientName, 'Mona');
      expect(request.giftRecipientPhone, '01012345678');
    });

    test('drops the gift recipient of a non gift order', () {
      final request = PlaceOrderRequest.fromParam(
        param(giftRecipientName: 'Mona', giftRecipientPhone: '01012345678'),
      );

      expect(request.isGift, isFalse);
      expect(request.giftRecipientName, isNull);
      expect(request.giftRecipientPhone, isNull);
    });

    test('omits the null gateway from the json payload', () {
      final json = PlaceOrderRequest.fromParam(param()).toJson();

      expect(json.containsKey('paymentGateway'), isFalse);
      expect(json, {
        'addressId': 'address-1',
        'paymentMethod': 'COD',
        'isGift': false,
      });
    });
  });
}
