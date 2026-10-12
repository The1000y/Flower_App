import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/animations/success_tracking_animation.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/order_tracking/presentation/view/order_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/order_tracking_test_helpers.dart';

Future<void> _pumpSuccess(WidgetTester tester) => pumpOrderTrackingApp(
  tester,
  const OrderSuccessView(),
  inScaffold: false,
);

Finder _trackOrderButton() =>
    find.widgetWithText(CustomButton, AppStrings.trackOrder);

void main() {
  group('OrderSuccessView - content', () {
    testWidgets('shows the "Track order" title in the app bar', (tester) async {
      await _pumpSuccess(tester);

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text(AppStrings.trackOrder),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows the success animation at 150x150', (tester) async {
      await _pumpSuccess(tester);

      expect(find.byType(SuccessTrackingAnimation), findsOneWidget);
      expect(
        tester.getSize(find.byType(SuccessTrackingAnimation)),
        const Size(150, 150),
      );
    });

    testWidgets('shows the "order placed successfully" message', (
      tester,
    ) async {
      await _pumpSuccess(tester);

      expect(find.text(AppStrings.orderPlacedSuccess), findsOneWidget);
    });

    testWidgets('shows a pink, enabled "Track order" button', (tester) async {
      await _pumpSuccess(tester);

      final button = tester.widget<CustomButton>(_trackOrderButton());
      expect(button.isEnabled, isTrue);
      expect(button.enabledColor, AppColors.pinkBase);
    });

    testWidgets('animation, then message, then button - from top to bottom', (
      tester,
    ) async {
      await _pumpSuccess(tester);

      final animationBottom = tester
          .getBottomLeft(find.byType(SuccessTrackingAnimation))
          .dy;
      final messageTop = tester
          .getTopLeft(find.text(AppStrings.orderPlacedSuccess))
          .dy;
      final buttonTop = tester.getTopLeft(_trackOrderButton()).dy;

      expect(animationBottom, lessThan(messageTop));
      expect(messageTop, lessThan(buttonTop));
    });
  });

  group('OrderSuccessView - animation', () {
    testWidgets('the success animation plays to the end without errors', (
      tester,
    ) async {
      await _pumpSuccess(tester);

      // The animation is finite (about 1.6 s), so settling is safe here.
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SuccessTrackingAnimation), findsOneWidget);
    });
  });

  group('OrderSuccessView - navigation', () {
    testWidgets('"Track order" opens the track order route', (tester) async {
      await _pumpSuccess(tester);

      await tester.tap(_trackOrderButton());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text(routeStubText(Routes.trackOrder)), findsOneWidget);
    });

    testWidgets('the back arrow closes the screen', (tester) async {
      await pumpOrderTrackingApp(
        tester,
        openScreenHome(const OrderSuccessView()),
        inScaffold: false,
      );

      await tester.tap(find.text(openButtonLabel));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(OrderSuccessView), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(OrderSuccessView), findsNothing);
      expect(find.text(openButtonLabel), findsOneWidget);
    });
  });
}
