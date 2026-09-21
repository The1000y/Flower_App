import 'package:flower_app/features/orders/domain/entities/my_orders_entity.dart';

abstract interface class OrdersRepo {
Future<List<OrderEntity>>getActiveOrders();
Future<List<OrderEntity>>getCompletedOrders();

}