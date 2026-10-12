abstract interface class OrderUpdateHandler {
  Future<void> onOrderUpdated(String orderId);
}
