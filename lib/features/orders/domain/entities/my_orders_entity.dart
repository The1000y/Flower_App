
import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String orderName;
  final String orderPrice;
  final String orderId;
  final String orderDeliverDate;
  final bool isActive;
  final String imageUrl;

  const OrderEntity({
    required this.orderName,
    required this.orderPrice,
    required this.orderId,
    required this.orderDeliverDate,
    required this.isActive,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        orderName,
        orderPrice,
        orderId,
        orderDeliverDate,
        isActive,
        imageUrl,
      ];
}