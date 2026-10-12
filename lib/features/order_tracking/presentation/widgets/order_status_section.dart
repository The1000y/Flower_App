import 'package:flutter/material.dart';

import '../../../../core/constants/enums/order_status.dart';
import '../../domain/entities/order_step_entity.dart';
import 'order_status_time_line.dart';

class OrderStatusSection extends StatelessWidget {
  const OrderStatusSection({super.key, required this.status});

  final OrderStatus status;

  static final _dummyDate = DateTime(2024, 9, 3, 2, 10); // UI-only placeholder

  @override
  Widget build(BuildContext context) {
    return OrderStatusTimeline(
      currentIndex: status.index,
      steps: [
        OrderStepEntity(title: 'Received your order', dateTime: _dummyDate),
        OrderStepEntity(
          title: 'Preparing your order',
          dateTime: status.index >= 1 ? _dummyDate : null,
        ),
        OrderStepEntity(
          title: 'Out for delivery',
          dateTime: status.index >= 2 ? _dummyDate : null,
        ),
        OrderStepEntity(
          title: 'Delivered',
          dateTime: status.index >= 3 ? _dummyDate : null,
        ),
      ],
    );
  }
}
