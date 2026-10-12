import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings/app_strings.dart';
import '../../../../core/constants/enums/order_status.dart';
import '../../domain/entities/order_step_entity.dart';
import 'order_status_time_line.dart';

class OrderStatusSection extends StatelessWidget {
  const OrderStatusSection({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return OrderStatusTimeline(
      currentIndex: status.index,
      steps: const [
        OrderStepEntity(title: AppStrings.statusReceived),
        OrderStepEntity(title: AppStrings.statusPreparing),
        OrderStepEntity(title: AppStrings.statusOutForDelivery),
        OrderStepEntity(title: AppStrings.statusDelivered),
      ],
    );
  }
}