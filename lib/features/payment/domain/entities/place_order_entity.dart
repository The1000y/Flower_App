class PlaceOrderEntity {
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
}