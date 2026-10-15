import 'package:flower_app/features/orders/data/model/response/orders_response.dart';

abstract interface class OrdersRemoteDataSource {
  Future<OrdersResponse> getOrders({required int page, required int limit});
}
