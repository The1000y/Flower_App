import 'package:flower_app/features/order_tracking/presentation/view/order_map_view.dart';
import 'package:flower_app/features/order_tracking/presentation/view/order_success_view.dart';
import 'package:flower_app/features/order_tracking/presentation/view/track_order_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpView(WidgetTester tester, Widget view) {
    return tester.pumpWidget(MaterialApp(home: view));
  }

  group('Order tracking views', () {
    // The tracking views are not implemented yet: each renders a bare
    // `Placeholder`. These smoke tests pin that contract so a real UI landing
    // later is a deliberate change, and they fail loudly if a view throws.
    testWidgets('TrackOrderView builds and renders a placeholder', (
      tester,
    ) async {
      await pumpView(tester, const TrackOrderView());

      expect(find.byType(Placeholder), findsOneWidget);
    });

    testWidgets('OrderMapView builds and renders a placeholder', (
      tester,
    ) async {
      await pumpView(tester, const OrderMapView());

      expect(find.byType(Placeholder), findsOneWidget);
    });

    testWidgets('OrderSuccessView builds and renders a placeholder', (
      tester,
    ) async {
      await pumpView(tester, const OrderSuccessView());

      expect(find.byType(Placeholder), findsOneWidget);
    });
  });
}
