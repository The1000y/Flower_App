import 'package:equatable/equatable.dart';

class PlaceOrderEntity extends Equatable {
  final String message;
  final String? orderId;
  final String? status;
  final String? gateway;
  final String? sessionUrl; // null في الكاش
  final String? sessionId;
  final String? successUrl;
  final String? cancelUrl;
  final DateTime? expiresAt;
  final double? amount;
  final String? currency;
  final DateTime? estimatedDeliveryAt;

  const PlaceOrderEntity({
    required this.message,
    this.orderId,
    this.status,
    this.gateway,
    this.sessionUrl,
    this.sessionId,
    this.successUrl,
    this.cancelUrl,
    this.expiresAt,
    this.amount,
    this.currency,
    this.estimatedDeliveryAt,
  });

  @override
  List<Object?> get props => [
    message,
    orderId,
    status,
    gateway,
    sessionUrl,
    sessionId,
    successUrl,
    cancelUrl,
    expiresAt,
    amount,
    currency,
    estimatedDeliveryAt,
  ];
}
