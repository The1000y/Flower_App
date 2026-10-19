
import 'package:flutter/material.dart';

import 'package:flower_app/l10n/l10n.dart';
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
        OrderStepEntity(title: context.l10n.statusReceived),
        OrderStepEntity(title: context.l10n.statusPreparing),
        OrderStepEntity(title: context.l10n.statusPickedUp),
        OrderStepEntity(title: context.l10n.statusOutForDelivery),
        OrderStepEntity(title: context.l10n.statusAwaitingConfirmation),
        OrderStepEntity(
          title: context.l10n.statusDelivered,
          dateTime: tracking.estimatedDeliveryAt,
        ),
      ],
    );
  }
}
