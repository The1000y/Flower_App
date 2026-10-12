import 'package:flower_app/core/constants/enums/order_status.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/order_status_section.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/order_status_time_line.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/order_tracking_test_helpers.dart';

const _titles = [
  'Received your order',
  'Preparing your order',
  'Out for delivery',
  'Delivered',
];

OrderStatusTimeline _timelineOf(WidgetTester tester) =>
    tester.widget<OrderStatusTimeline>(find.byType(OrderStatusTimeline));

void main() {
  group('OrderStatusSection', () {
    for (final status in OrderStatus.values) {
      group('status ${status.name}', () {
        testWidgets('passes the status index to the timeline', (tester) async {
          await pumpOrderTrackingApp(tester, OrderStatusSection(status: status));

          expect(_timelineOf(tester).currentIndex, status.index);
        });

        testWidgets('always builds the four steps in the same order', (
          tester,
        ) async {
          await pumpOrderTrackingApp(tester, OrderStatusSection(status: status));

          expect(_timelineOf(tester).steps.map((s) => s.title), _titles);
        });

        testWidgets('steps carry no timestamp until the API provides one', (
          tester,
        ) async {
          await pumpOrderTrackingApp(tester, OrderStatusSection(status: status));

          final hasDate = _timelineOf(
            tester,
          ).steps.map((s) => s.dateTime != null).toList();

          expect(hasDate, [false, false, false, false]);
        });
      });
    }

    testWidgets('shows the four titles on screen', (tester) async {
      await pumpOrderTrackingApp(
        tester,
        const OrderStatusSection(status: OrderStatus.preparing),
      );

      for (final title in _titles) {
        expect(find.text(title), findsOneWidget);
      }
    });
  });
}