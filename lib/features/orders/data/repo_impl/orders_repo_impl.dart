import 'package:flower_app/features/orders/data/data_source/remote_data_source/orders_remote_data_source.dart';
import 'package:flower_app/features/orders/domain/entities/my_orders_entity.dart';
import 'package:flower_app/features/orders/domain/repo/orders_repo.dart';
import 'package:injectable/injectable.dart';
@Injectable(as:OrdersRepo)
class OrdersRepoImpl implements OrdersRepo{
  final OrdersRemoteDataSource ordersRemoteDataSource;

  OrdersRepoImpl(this.ordersRemoteDataSource);
  @override
  Future<List<OrderEntity>> getActiveOrders() {
    // TODO: implement getActiveOrders
    throw UnimplementedError();
  }

  @override
  Future<List<OrderEntity>> getCompletedOrders() {
    // TODO: implement getCompletedOrders
    throw UnimplementedError();
  }


}