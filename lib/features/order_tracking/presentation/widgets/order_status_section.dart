import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/order_status_mapper.dart';
import '../../domain/entities/order_step_entity.dart';
import '../../domain/entities/tracking_entity.dart';
import 'order_status_time_line.dart';

class OrderStatusSection extends StatelessWidget {
  const OrderStatusSection({super.key, required this.tracking});

  final TrackingEntity tracking;

  @override
  Widget build(BuildContext context) {
    final status = orderStatusFromApi(tracking.status);

    return OrderStatusTimeline(
      currentIndex: status.index,
      steps: [
        const OrderStepEntity(title: AppStrings.statusReceived),
        const OrderStepEntity(title: AppStrings.statusPreparing),
        const OrderStepEntity(title: AppStrings.statusOutForDelivery),
        OrderStepEntity(
          title: AppStrings.statusDelivered,
          dateTime: tracking.estimatedDeliveryAt,
        ),
      ],
    );
  }
}
