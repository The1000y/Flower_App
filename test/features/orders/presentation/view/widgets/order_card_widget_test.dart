import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/orders/presentation/view/widgets/order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest(Widget widget) {
    return ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        home: Scaffold(body: widget),
      ),
    );
  }

  group('OrderCardWidget', () {
    testWidgets(
        'renders active order card details and calls callback when tapped',
        (tester) async {
      bool buttonTapped = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          OrderCardWidget(
            orderName: "Red Roses Bouquet",
            orderPrice: "600 EGP",
            orderId: "98231",
            orderDeliverDate: "22 Sep",
            isActive: true,
            imageUrl: "https://example.com/rose.png",
            onActionPressed: () => buttonTapped = true,
          ),
        ),
      );

      expect(find.text("Red Roses Bouquet"), findsOneWidget);
      expect(find.text("600 EGP"), findsOneWidget);
      expect(
        find.text("${AppStrings.orderNumberPrefix}98231"),
        findsOneWidget,
      );
      expect(find.text(AppStrings.trackOrder), findsOneWidget);

      await tester.tap(find.text(AppStrings.trackOrder));
      expect(buttonTapped, isTrue);
    });

    testWidgets('renders completed order card details', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          OrderCardWidget(
            orderName: "Pink Lily Basket",
            orderPrice: "400 EGP",
            orderId: "98232",
            orderDeliverDate: "15 Sep",
            isActive: false,
            imageUrl: "https://example.com/lily.png",
            onActionPressed: () {},
          ),
        ),
      );

      expect(find.text("Pink Lily Basket"), findsOneWidget);
      expect(find.text("400 EGP"), findsOneWidget);
      expect(
        find.text("${AppStrings.deliveredOnPrefix}15 Sep"),
        findsOneWidget,
      );
      expect(find.text(AppStrings.reorder), findsOneWidget);
    });
  });
}
