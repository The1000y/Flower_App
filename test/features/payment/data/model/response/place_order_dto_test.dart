import 'package:flower_app/features/payment/data/model/response/place_order_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses and maps the payment session response', () {
    final dto = PlaceOrderDto.fromJson({
      'orderId': '01a0f165-2397-7001-8507-1d5d824bc659',
      'status': 'PendingPayment',
      'gateway': 'Paymob',
      'sessionId': 'sess_dab477ac83224739925d12f05aa38bcc',
      'sessionUrl': 'https://accept.paymob.com/unifiedcheckout/',
      'successUrl': 'flowery://payment/success?orderId=order-1',
      'cancelUrl': 'flowery://payment/cancel?orderId=order-1',
      'expiresAt': '2026-09-30T08:48:53.1990332Z',
      'amount': 165.25,
      'currency': 'EGP',
      'estimatedDeliveryAt': '2026-09-30T08:53:52.4392028Z',
    });

    final entity = dto.toEntity();

    expect(entity.orderId, '01a0f165-2397-7001-8507-1d5d824bc659');
    expect(entity.status, 'PendingPayment');
    expect(entity.gateway, 'Paymob');
    expect(entity.sessionId, 'sess_dab477ac83224739925d12f05aa38bcc');
    expect(entity.sessionUrl, 'https://accept.paymob.com/unifiedcheckout/');
    expect(entity.successUrl, 'flowery://payment/success?orderId=order-1');
    expect(entity.cancelUrl, 'flowery://payment/cancel?orderId=order-1');
    expect(entity.expiresAt, DateTime.parse('2026-09-30T08:48:53.1990332Z'));
    expect(entity.amount, 165.25);
    expect(entity.currency, 'EGP');
    expect(
      entity.estimatedDeliveryAt,
      DateTime.parse('2026-09-30T08:53:52.4392028Z'),
    );
  });
}