import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/order_tracking/presentation/manager/tracking_view_model.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_tracking_buttons_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_tracking_view_model.dart';
import '../../../../helpers/order_tracking_test_helpers.dart';

Finder _showMapButton() =>
    find.widgetWithText(CustomButton, AppStrings.showMap);

Finder _deliveredButton() =>
    find.widgetWithText(CustomButton, AppStrings.orderDeliveredAction);

Widget _section({required bool isDelivered}) {
  final viewModel = FakeTrackingViewModel();
  addTearDown(viewModel.close);

  return BlocProvider<TrackingViewModel>.value(
    value: viewModel,
    child: CustomTrackingButtonsSection(isDelivered: isDelivered),
  );
}

void main() {
  group('CustomTrackingButtonsSection - visibility', () {
    testWidgets('not delivered: only the "Show map" button is shown', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _section(isDelivered: false));

      expect(find.byType(CustomButton), findsOneWidget);
      expect(_showMapButton(), findsOneWidget);
      expect(_deliveredButton(), findsNothing);
    });

    testWidgets('delivered: both "Show map" and "Order Delivered" are shown', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _section(isDelivered: true));

      expect(find.byType(CustomButton), findsNWidgets(2));
      expect(_showMapButton(), findsOneWidget);
      expect(_deliveredButton(), findsOneWidget);
    });

    testWidgets('the second button appears when isDelivered becomes true', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _section(isDelivered: false));
      expect(_deliveredButton(), findsNothing);

      await pumpOrderTrackingApp(tester, _section(isDelivered: true));

      expect(_deliveredButton(), findsOneWidget);
    });

    testWidgets('the second button disappears when isDelivered becomes false', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _section(isDelivered: true));
      expect(_deliveredButton(), findsOneWidget);

      await pumpOrderTrackingApp(tester, _section(isDelivered: false));

      expect(_deliveredButton(), findsNothing);
    });
  });

  group('CustomTrackingButtonsSection - layout', () {
    testWidgets('a lone "Show map" button takes the full width', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _section(isDelivered: false));

      final rowWidth = tester
          .getSize(find.byType(CustomTrackingButtonsSection))
          .width;
      expect(tester.getSize(_showMapButton()).width, closeTo(rowWidth, 0.01));
    });

    testWidgets('two buttons share the width equally', (tester) async {
      await pumpOrderTrackingApp(tester, _section(isDelivered: true));

      expect(
        tester.getSize(_showMapButton()).width,
        closeTo(tester.getSize(_deliveredButton()).width, 0.01),
      );
    });

    testWidgets('there is an 8px gap between the two buttons', (tester) async {
      await pumpOrderTrackingApp(tester, _section(isDelivered: true));

      final gap =
          tester.getTopLeft(_deliveredButton()).dx -
          tester.getTopRight(_showMapButton()).dx;
      expect(gap, closeTo(8, 0.01));
    });

    testWidgets('"Show map" is on the left of "Order Delivered"', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _section(isDelivered: true));

      expect(
        tester.getTopLeft(_showMapButton()).dx,
        lessThan(tester.getTopLeft(_deliveredButton()).dx),
      );
    });
  });

  group('CustomTrackingButtonsSection - appearance', () {
    testWidgets('both buttons are enabled and use the pink brand color', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _section(isDelivered: true));

      for (final finder in [_showMapButton(), _deliveredButton()]) {
        final button = tester.widget<CustomButton>(finder);
        expect(button.isEnabled, isTrue);
        expect(button.enabledColor, AppColors.pinkBase);
      }
    });
  });

  group('CustomTrackingButtonsSection - actions', () {
    testWidgets('tapping "Show map" opens the order map route', (tester) async {
      await pumpOrderTrackingApp(tester, _section(isDelivered: false));

      await tester.tap(_showMapButton());
      await tester.pumpAndSettle();

      expect(find.text(routeStubText(Routes.orderMap)), findsOneWidget);
    });

    testWidgets('"Show map" also works once the order is delivered', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _section(isDelivered: true));

      await tester.tap(_showMapButton());
      await tester.pumpAndSettle();

      expect(find.text(routeStubText(Routes.orderMap)), findsOneWidget);
    });

    // The "Order Delivered" action is still a TODO in the widget. When it is
    // implemented, replace this test with one that checks the real behavior.
    testWidgets('tapping "Order Delivered" does nothing yet (no crash, no navigation)', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _section(isDelivered: true));

      await tester.tap(_deliveredButton());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(CustomTrackingButtonsSection), findsOneWidget);
      expect(find.textContaining('route:'), findsNothing);
    });
  });
}
