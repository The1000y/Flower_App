import 'package:flower_app/features/orders/domain/entities/my_orders_entity.dart';

abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersSuccess extends OrdersState {
  final List<OrderEntity> activeOrders;
  final List<OrderEntity> completedOrders;

  OrdersSuccess({required this.activeOrders, required this.completedOrders});
}

class OrdersError extends OrdersState {
  final String message;

  OrdersError(this.message);
}
