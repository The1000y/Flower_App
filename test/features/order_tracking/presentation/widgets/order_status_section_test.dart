import 'package:flower_app/core/constants/enums/order_status.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/order_status_section.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/order_status_time_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/order_tracking_test_helpers.dart';

const _titles = [
  'Received your order',
  'Preparing your order',
  'Out for delivery',
  'Delivered',
];
const _formattedDummyDate = '03 Sep 2024 - 2:10';

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

        testWidgets('only the reached steps carry a date', (tester) async {
          await pumpOrderTrackingApp(tester, OrderStatusSection(status: status));

          final hasDate = _timelineOf(
            tester,
          ).steps.map((s) => s.dateTime != null).toList();

          expect(hasDate, [for (var i = 0; i < 4; i++) i <= status.index]);
          expect(find.text(_formattedDummyDate), findsNWidgets(status.index + 1));
        });
      });
    }

    testWidgets('the first step (received) always has a date', (tester) async {
      await pumpOrderTrackingApp(
        tester,
        const OrderStatusSection(status: OrderStatus.received),
      );

      expect(
        _timelineOf(tester).steps.first.dateTime,
        DateTime(2024, 9, 3, 2, 10),
      );
    });

    testWidgets('moving to a later status reveals the next dates', (
      tester,
    ) async {
      await pumpOrderTrackingApp(
        tester,
        const OrderStatusSection(status: OrderStatus.received),
      );
      expect(find.text(_formattedDummyDate), findsOneWidget);

      await pumpOrderTrackingApp(
        tester,
        const OrderStatusSection(status: OrderStatus.delivered),
      );
      await tester.pumpAndSettle();

      expect(find.text(_formattedDummyDate), findsNWidgets(4));
      expect(_timelineOf(tester).currentIndex, OrderStatus.delivered.index);
    });

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
