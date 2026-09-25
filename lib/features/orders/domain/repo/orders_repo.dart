import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/orders/domain/entities/my_orders_entity.dart';

abstract interface class OrdersRepo {
  Future<BaseResponce<List<OrderEntity>>> getOrders({required int page, required int limit});
}