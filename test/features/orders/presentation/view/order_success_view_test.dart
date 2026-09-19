import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/features/orders/presentation/view/order_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  Widget createWidgetUnderTest({String? orderId}) {
    return ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        home: OrderSuccessView(orderId: orderId),
        navigatorObservers: [mockObserver],
        routes: {
          Routes.home: (context) => const Scaffold(body: Text('Home')),
          Routes.trackOrder: (context) =>
              const Scaffold(body: Text('Track Order')),
        },
      ),
    );
  }

  group('OrderSuccessView Interaction Tests', () {
    testWidgets('renders success message, icon, and track order button', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text(AppStrings.orderPlacedSuccess), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.text(AppStrings.trackOrder), findsWidgets);
    });

    testWidgets('displays order ID when provided', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(orderId: '12345'));

      expect(find.text('${AppStrings.orderIdPrefix}12345'), findsOneWidget);
    });

    testWidgets(
      'tapping track order button triggers navigation to trackOrder with orderId',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(orderId: '12345'));

        await tester.tap(find.byType(CustomButton));
        await tester.pumpAndSettle();

        verify(
          () => mockObserver.didPush(any(), any()),
        ).called(greaterThanOrEqualTo(1));
      },
    );

    testWidgets('tapping back button triggers navigation to home', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      verify(
        () => mockObserver.didPush(any(), any()),
      ).called(greaterThanOrEqualTo(1));
    });
  });
}
