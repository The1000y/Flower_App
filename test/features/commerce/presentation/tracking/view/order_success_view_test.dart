import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/features/commerce/presentation/tracking/view/order_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  void setPhoneSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget createWidgetUnderTest({String? orderId}) {
    return ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        home: OrderSuccessView(orderId: orderId),
      ),
    );
  }

  group('OrderSuccessView Tests', () {
    testWidgets('renders success message, icon, and track order button', (tester) async {
      setPhoneSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text(AppStrings.orderPlacedSuccess), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.text(AppStrings.trackOrder), findsWidgets);
    });

    testWidgets('displays order ID when provided', (tester) async {
      setPhoneSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest(orderId: '12345'));

      expect(find.text('${AppStrings.orderIdPrefix}12345'), findsOneWidget);
    });

    testWidgets('does not display order ID widget when orderId is null', (tester) async {
      setPhoneSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest(orderId: null));

      expect(find.textContaining(AppStrings.orderIdPrefix), findsNothing);
    });
  });
}
