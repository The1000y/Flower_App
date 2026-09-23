import 'package:flower_app/features/orders/api/client/orders_api_client.dart';
import 'package:flower_app/features/orders/data/data_source/remote_data_source/orders_remote_data_source.dart';
import 'package:flower_app/features/orders/data/model/response/orders_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
final OrdersApiClient ordersApiClient;

  OrdersRemoteDataSourceImpl(this.ordersApiClient);

  @override
  Future<OrdersResponse> getOrders({required int page, required int limit}) {
   return ordersApiClient.getOrders(page, limit);
  }

}
