import 'package:flower_app/features/orders/domain/entities/my_orders_entity.dart';
import 'package:flower_app/features/orders/domain/repo/orders_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrdersUseCase {
  final OrdersRepo ordersRepo;

  GetOrdersUseCase(this.ordersRepo);

  Future<List<OrderEntity>> call({required int page, required int limit}) async {
    return await ordersRepo.getOrders(page: page, limit: limit);
  }
}
