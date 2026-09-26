import 'package:equatable/equatable.dart';

class CheckoutDetailsEntity extends Equatable {
  final int subtotal;
  final int deliveryFee;
  final int total;
  final String estimatedDeliveryAt;
  final List<PaymentMethodEntity> paymentMethods;
  final bool isGift;
  final String? giftRecipientName;
  final String? giftRecipientPhone;

  const CheckoutDetailsEntity({
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.estimatedDeliveryAt,
    required this.paymentMethods,
    required this.isGift,
    this.giftRecipientName,
    this.giftRecipientPhone,
  });

  @override
  List<Object?> get props => [
    subtotal,
    deliveryFee,
    total,
    estimatedDeliveryAt,
    paymentMethods,
    isGift,
    giftRecipientName,
    giftRecipientPhone,
  ];
}

class PaymentMethodEntity extends Equatable {
  final String method;
  final List<String> gateways;

  const PaymentMethodEntity({required this.method, required this.gateways});

  @override
  List<Object?> get props => [method, gateways];
}
