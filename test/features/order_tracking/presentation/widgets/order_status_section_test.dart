import 'package:flower_app/core/constants/enums/order_status.dart';
import 'package:flower_app/features/order_tracking/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/order_status_section.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/order_status_time_line.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/order_tracking_test_helpers.dart';

const _titles = [
  'Received your order',
  'Preparing your order',
  'Picked up by the driver',
  'Out for delivery',
  'Awaiting your confirmation',
  'Delivered',
];

final _estimatedArrival = DateTime(2024, 9, 3, 2, 10);

TrackingEntity _tracking(String status) => TrackingEntity(
  orderId: 'o-1',
  status: status,
  estimatedDeliveryAt: _estimatedArrival,
);

OrderStatusTimeline _timelineOf(WidgetTester tester) =>
    tester.widget<OrderStatusTimeline>(find.byType(OrderStatusTimeline));

void main() {
  group('OrderStatusSection', () {
    for (final status in OrderStatus.values) {
      group('status ${status.name}', () {
        testWidgets('maps the api status to the timeline index', (tester) async {
          await pumpOrderTrackingApp(
            tester,
            OrderStatusSection(tracking: _tracking(status.name)),
          );

          expect(_timelineOf(tester).currentIndex, status.index);
        });

        testWidgets('always builds the steps in the same order', (
          tester,
        ) async {
          await pumpOrderTrackingApp(
            tester,
            OrderStatusSection(tracking: _tracking(status.name)),
          );

          expect(_timelineOf(tester).steps.map((s) => s.title), _titles);
        });
      });
    }

    testWidgets('shows the estimated delivery date only on the delivered step', (
      tester,
    ) async {
      await pumpOrderTrackingApp(
        tester,
        OrderStatusSection(tracking: _tracking('Preparing')),
      );

      final steps = _timelineOf(tester).steps;
      expect(steps.last.dateTime, _estimatedArrival);
      expect(steps.take(steps.length - 1).every((s) => s.dateTime == null), isTrue);
    });

    testWidgets('shows every step title on screen', (tester) async {
      await pumpOrderTrackingApp(
        tester,
        OrderStatusSection(tracking: _tracking('Preparing')),
      );

      for (final title in _titles) {
        expect(find.text(title), findsOneWidget);
      }
    });
  });
}
