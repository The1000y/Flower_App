import 'package:flower_app/features/orders/domain/entities/my_orders_entity.dart';
import 'package:flower_app/features/orders/presentation/view/widgets/order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class OrdersListWidget extends StatelessWidget {
  final List<OrderEntity> orders;
  final Function(String) onActionPressed;
  final VoidCallback onLoadMore;

  const OrdersListWidget({
    super.key,
    required this.orders,
    required this.onActionPressed,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.separated(
        padding: EdgeInsets.all(16.r),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final currentOrder = orders[index];
          return OrderCardWidget(
            orderName: currentOrder.orderName,
            orderPrice: currentOrder.orderPrice,
            orderId: currentOrder.orderId,
            orderDeliverDate: currentOrder.orderDeliverDate,
            isActive: currentOrder.isActive,
            imageUrl: currentOrder.imageUrl,
            onActionPressed: () => onActionPressed(currentOrder.orderId),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 20),
      ),
    );
  }
}
