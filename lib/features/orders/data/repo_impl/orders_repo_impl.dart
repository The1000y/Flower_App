import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/orders/domain/entities/my_orders_entity.dart';
import 'package:flower_app/features/orders/domain/repo/orders_repo.dart';
import 'package:injectable/injectable.dart';

import '../data_source/remote_data_source/orders_remote_data_source.dart';

@Injectable(as: OrdersRepo)
class OrdersRepoImpl implements OrdersRepo {
  final OrdersRemoteDataSource ordersRemoteDataSource;

  OrdersRepoImpl(this.ordersRemoteDataSource);

  @override
  Future<BaseResponce<List<OrderEntity>>> getOrders({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await ordersRemoteDataSource.getOrders(
        page: page,
        limit: limit,
      );
      final List<OrderEntity> orderList = response.data.map((dto) {
        return OrderEntity(
          orderName: dto.orderTitle,
          orderPrice: dto.totalPrice,
          orderId: dto.orderId,
          orderDeliverDate: dto.deliveryDate,
          isActive: dto.isActive,
          imageUrl: dto.coverImage,
        );
      }).toList();
      return SuccessResponce(orderList);
    } on Exception catch (e) {
      return ErrorResponce(e);
    } catch (e) {
      return ErrorResponce(Exception(e.toString()));
    }
  }
}
