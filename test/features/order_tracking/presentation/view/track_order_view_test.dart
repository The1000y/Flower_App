import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/animations/animated_car_single_file.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/features/order_tracking/presentation/view/track_order_view.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_contract_card.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_delivery_boy_information_card.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_estimated_arrival_section.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_tracking_buttons_section.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/order_status_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/order_tracking_test_helpers.dart';

// NOTE: this screen contains the driving car, an animation that never ends, so
// these tests use fixed-length pumps instead of pumpAndSettle.

const _formattedDummyDate = '03 Sep 2024 - 2:10';

Future<void> _pumpTrackOrder(
  WidgetTester tester, {
  Size surfaceSize = const Size(800, 1400),
}) => pumpOrderTrackingApp(
  tester,
  const TrackOrderView(),
  inScaffold: false,
  surfaceSize: surfaceSize,
);

Finder _showMapButton() =>
    find.widgetWithText(CustomButton, AppStrings.showMap);

Finder _deliveredButton() =>
    find.widgetWithText(CustomButton, AppStrings.orderDeliveredAction);

/// Taps the TEMP floating button that cycles the status, then lets the
/// timeline (700 ms) and date fade (400 ms) animations finish.
Future<void> _tapNextStatus(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.skip_next));
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  group('TrackOrderView - content', () {
    testWidgets('shows the "Track order" title in the app bar', (tester) async {
      await _pumpTrackOrder(tester);

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text(AppStrings.trackOrder),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows every section of the screen', (tester) async {
      await _pumpTrackOrder(tester);

      expect(find.byType(CustomEstimatedArrivalSection), findsOneWidget);
      expect(find.byType(CustomDeliveryBoyInformationCard), findsOneWidget);
      expect(find.byType(AnimatedCar), findsOneWidget);
      expect(find.byType(OrderStatusSection), findsOneWidget);
      expect(find.byType(CustomTrackingButtonsSection), findsOneWidget);
    });

    // Dummy data for now (UI-only task). Update when real data is wired in.
    testWidgets('shows the dummy delivery boy', (tester) async {
      await _pumpTrackOrder(tester);

      expect(find.text('Mohamed'), findsOneWidget);
      expect(
        tester.widget<CustomContactCard>(find.byType(CustomContactCard)).phoneNumber,
        '01014194042',
      );
    });

    testWidgets('the car keeps animating without errors', (tester) async {
      await _pumpTrackOrder(tester);

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.takeException(), isNull);
    });

    testWidgets('sections are stacked in the expected order', (tester) async {
      await _pumpTrackOrder(tester);

      final arrival = tester.getTopLeft(find.byType(CustomEstimatedArrivalSection)).dy;
      final card = tester.getTopLeft(find.byType(CustomDeliveryBoyInformationCard)).dy;
      final car = tester.getTopLeft(find.byType(AnimatedCar)).dy;
      final timeline = tester.getTopLeft(find.byType(OrderStatusSection)).dy;
      final buttons = tester.getTopLeft(find.byType(CustomTrackingButtonsSection)).dy;

      expect(arrival, lessThan(card));
      expect(card, lessThan(car));
      expect(car, lessThan(timeline));
      expect(timeline, lessThan(buttons));
    });
  });

  group('TrackOrderView - scrolling', () {
    testWidgets('the content is inside the scroll view', (tester) async {
      await _pumpTrackOrder(tester);

      for (final type in [
        CustomEstimatedArrivalSection,
        CustomDeliveryBoyInformationCard,
        AnimatedCar,
        OrderStatusSection,
      ]) {
        expect(
          find.descendant(
            of: find.byType(CustomScrollView),
            matching: find.byType(type),
          ),
          findsOneWidget,
          reason: '$type should scroll with the page',
        );
      }
    });

    testWidgets('the bottom buttons are NOT inside the scroll view', (
      tester,
    ) async {
      await _pumpTrackOrder(tester);

      expect(
        find.descendant(
          of: find.byType(CustomScrollView),
          matching: find.byType(CustomTrackingButtonsSection),
        ),
        findsNothing,
      );
    });

    testWidgets('scrolling moves the content but the buttons stay in place', (
      tester,
    ) async {
      // A short screen so the content is taller than the scrollable area.
      await _pumpTrackOrder(tester, surfaceSize: const Size(800, 500));

      final buttonsBefore = tester.getTopLeft(find.byType(CustomTrackingButtonsSection));
      final lastStepBefore = tester.getTopLeft(find.text('Delivered')).dy;

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await tester.pump();

      final lastStepAfter = tester.getTopLeft(find.text('Delivered')).dy;
      expect(lastStepAfter, lessThan(lastStepBefore - 100));
      expect(
        tester.getTopLeft(find.byType(CustomTrackingButtonsSection)),
        buttonsBefore,
      );
    });
  });

  group('TrackOrderView - buttons', () {
    testWidgets('starts on "Received": only "Show map" is available', (
      tester,
    ) async {
      await _pumpTrackOrder(tester);

      expect(_showMapButton(), findsOneWidget);
      expect(_deliveredButton(), findsNothing);
      expect(find.text(_formattedDummyDate), findsOneWidget);
    });

    testWidgets('"Show map" opens the order map route', (tester) async {
      await _pumpTrackOrder(tester);

      await tester.tap(_showMapButton());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text(routeStubText(Routes.orderMap)), findsOneWidget);
    });
  });

  group('TrackOrderView - navigation', () {
    testWidgets('the back arrow closes the screen', (tester) async {
      await pumpOrderTrackingApp(
        tester,
        openScreenHome(const TrackOrderView()),
        inScaffold: false,
      );

      await tester.tap(find.text(openButtonLabel));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(TrackOrderView), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(TrackOrderView), findsNothing);
      expect(find.text(openButtonLabel), findsOneWidget);
    });
  });

  // TEMPORARY: these exercise the debug floating button that cycles through
  // the statuses. Delete or replace the group when the cubit replaces it.
  group('TrackOrderView - status cycling (temporary debug button)', () {
    testWidgets('shows the debug button', (tester) async {
      await _pumpTrackOrder(tester);

      expect(find.byIcon(Icons.skip_next), findsOneWidget);
    });

    testWidgets('"Preparing": a second step gets its date, still one button', (
      tester,
    ) async {
      await _pumpTrackOrder(tester);

      await _tapNextStatus(tester);

      expect(find.text(_formattedDummyDate), findsNWidgets(2));
      expect(_deliveredButton(), findsNothing);
    });

    testWidgets('"Out for delivery": three dates, still no delivered button', (
      tester,
    ) async {
      await _pumpTrackOrder(tester);

      await _tapNextStatus(tester);
      await _tapNextStatus(tester);

      expect(find.text(_formattedDummyDate), findsNWidgets(3));
      expect(_deliveredButton(), findsNothing);
    });

    testWidgets('"Delivered": all four dates and the second button show up', (
      tester,
    ) async {
      await _pumpTrackOrder(tester);

      await _tapNextStatus(tester);
      await _tapNextStatus(tester);
      await _tapNextStatus(tester);

      expect(find.text(_formattedDummyDate), findsNWidgets(4));
      expect(_showMapButton(), findsOneWidget);
      expect(_deliveredButton(), findsOneWidget);
    });

    testWidgets('after "Delivered" the cycle wraps back to "Received"', (
      tester,
    ) async {
      await _pumpTrackOrder(tester);

      for (var i = 0; i < 4; i++) {
        await _tapNextStatus(tester);
      }

      expect(find.text(_formattedDummyDate), findsOneWidget);
      expect(_deliveredButton(), findsNothing);
    });
  });
}
