class PlaceOrderEntity {
  final String message;
  final String? sessionUrl; // null في الكاش
  final String? sessionId;

  const PlaceOrderEntity({
    required this.message,
    this.sessionUrl,
    this.sessionId,
  });
}