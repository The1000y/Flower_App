import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/orders/domain/entities/my_orders_entity.dart';
import 'package:flower_app/features/orders/domain/repo/orders_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrdersUseCase {
  final OrdersRepo ordersRepo;

  GetOrdersUseCase(this.ordersRepo);

  Future<BaseResponce<({List<OrderEntity> activeOrders, List<OrderEntity> completedOrders})>> call({
    required int page,
    required int limit,
  }) async {
    final response = await ordersRepo.getOrders(page: page, limit: limit);
    switch (response) {
      case SuccessResponce<List<OrderEntity>>():
        final active = response.data.where((order) => order.isActive).toList();
        final completed = response.data.where((order) => !order.isActive).toList();
        return SuccessResponce((activeOrders: active, completedOrders: completed));
      case ErrorResponce<List<OrderEntity>>():
        return ErrorResponce(response.error);
    }
  }
}
