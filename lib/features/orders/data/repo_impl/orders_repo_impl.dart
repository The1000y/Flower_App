import 'package:flower_app/features/orders/domain/entities/my_orders_entity.dart';
import 'package:flower_app/features/orders/domain/repo/orders_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrdersRepo)
class OrdersRepoImpl implements OrdersRepo {
  // final OrdersRemoteDataSource ordersRemoteDataSource;
  //
  // OrdersRepoImpl(this.ordersRemoteDataSource);

  @override
  Future<List<OrderEntity>> getActiveOrders() async {
    // TODO: DELETE THIS DUMMY DATA WHEN API IS READY
    return [
      OrderEntity(
        orderName: "Sunflowers Bouquet",
        orderPrice: "150 EGP",
        orderId: "ORD-1024",
        orderDeliverDate: "2026-09-18",
        isActive: true,
        imageUrl: "https://grist.org/wp-content/uploads/2021/08/sunflower.jpg",
      ),
      OrderEntity(
        orderName: "White Lilies",
        orderPrice: "220 EGP",
        orderId: "ORD-1026",
        orderDeliverDate: "2026-09-20",
        isActive: true,
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Lilium_candidum_1.jpg/800px-Lilium_candidum_1.jpg",
      ),
    ];

    /* TODO: UNCOMMENT THIS BLOCK WHEN API IS READY
    final response = await ordersRemoteDataSource.getActiveOrders();
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
    return orderList;
    */
  }

  @override
  Future<List<OrderEntity>> getCompletedOrders() async {
    // TODO: DELETE THIS DUMMY DATA WHEN API IS READY
    return [
      OrderEntity(
        orderName: "Red Roses",
        orderPrice: "200 EGP",
        orderId: "ORD-1001",
        orderDeliverDate: "2026-09-10", // تاريخ قديم
        isActive: false, // خلينا دي false عشان ده Completed
        imageUrl:
            "https://www.thespruce.com/thmb/xM5z-Bhe_3wZ3kOksQkC229qK-Y=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/red-roses-58a6927a3df78c345b1338d3.jpg",
      ),
    ];

    /* TODO: UNCOMMENT THIS BLOCK WHEN API IS READY
    final response = await ordersRemoteDataSource.getCompletedOrders();
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
    return orderList;
    */
  }
}
