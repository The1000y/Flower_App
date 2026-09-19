class OrderEntity {
  final String orderName;
  final String orderPrice;
  final String orderId;
  final String orderDeliverDate;
  final bool isActive;
  final String imageUrl;

  OrderEntity({
    required this.orderName,
    required this.orderPrice,
    required this.orderId,
    required this.orderDeliverDate,
    required this.isActive,
    required this.imageUrl,
  });
}
