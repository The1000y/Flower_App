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
  final String? cartId;
  final String? addressId;

  const CheckoutDetailsEntity({
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.estimatedDeliveryAt,
    required this.paymentMethods,
    required this.isGift,
    this.giftRecipientName,
    this.giftRecipientPhone,
    this.cartId,
    this.addressId,
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
    cartId,
    addressId,
  ];
}

class PaymentMethodEntity extends Equatable {
  final String method;
  final List<String> gateways;

  const PaymentMethodEntity({required this.method, required this.gateways});

  @override
  List<Object?> get props => [method, gateways];
}
