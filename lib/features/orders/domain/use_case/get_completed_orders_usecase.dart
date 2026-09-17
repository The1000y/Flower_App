import 'package:flower_app/features/orders/domain/entities/my_orders_entity.dart';
import 'package:flower_app/features/orders/domain/repo/orders_repo.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetCompletedOrdersUseCase{
  final OrdersRepo ordersRepo;

  GetCompletedOrdersUseCase(this.ordersRepo);
  Future<List<OrderEntity>>call()async{
    return await ordersRepo.getCompletedOrders();

  }


}