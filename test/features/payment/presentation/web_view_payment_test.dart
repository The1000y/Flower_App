import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/features/payment/presentation/web_view_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../helpers/fake_webview_platform.dart';

void main() {
  const sessionUrl = 'https://accept.paymob.com/unifiedcheckout/session';
  const successUrl = 'flowery://payment/success?orderId=order-1';
  const cancelUrl = 'flowery://payment/cancel?orderId=order-1';
  const orderSuccessRoute = 'order-success-route';
  const checkoutRoute = 'checkout-route';

  late FakeWebViewPlatform fakePlatform;

  setUp(() {
    fakePlatform = FakeWebViewPlatform();
    WebViewPlatform.instance = fakePlatform;
  });

  Future<void> pumpPayment(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          Routes.orderSuccess: (_) => const Text(orderSuccessRoute),
          Routes.checkout: (_) => const Text(checkoutRoute),
        },
        home: const WebViewPayment(
          sessionUrl: sessionUrl,
          successUrl: successUrl,
          cancelUrl: cancelUrl,
        ),
      ),
    );
  }

  Future<void> pumpFrames(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('WebViewPayment', () {
    testWidgets('loads the session url with a navigation delegate', (
      tester,
    ) async {
      // Act
      await pumpPayment(tester);

      // Assert
      expect(fakePlatform.controllers, hasLength(1));
      expect(fakePlatform.lastController.loadedUrl, sessionUrl);
      expect(fakePlatform.lastController.javaScriptModes, [
        JavaScriptMode.unrestricted,
      ]);
      expect(fakePlatform.lastController.navigationDelegate, isNotNull);
      expect(fakePlatform.lastDelegate.onNavigationRequest, isNotNull);
      expect(find.byType(WebViewWidget), findsOneWidget);
    });

    testWidgets('renders the payment app bar with both shortcuts', (
      tester,
    ) async {
      // Act
      await pumpPayment(tester);

      // Assert
      expect(find.text('Payment'), findsOneWidget);
      expect(find.byIcon(Icons.web_asset_outlined), findsOneWidget);
      expect(find.byIcon(Icons.web_asset_off_rounded), findsOneWidget);
    });

    testWidgets('tapping the success shortcut opens the success route', (
      tester,
    ) async {
      // Act
      await pumpPayment(tester);
      await tester.tap(find.byIcon(Icons.web_asset_outlined));
      await pumpFrames(tester);

      // Assert
      expect(find.text(orderSuccessRoute), findsOneWidget);
      expect(find.byType(WebViewPayment), findsNothing);
    });

    testWidgets('tapping the cancel shortcut opens the checkout route', (
      tester,
    ) async {
      // Act
      await pumpPayment(tester);
      await tester.tap(find.byIcon(Icons.web_asset_off_rounded));
      await pumpFrames(tester);

      // Assert
      expect(find.text(checkoutRoute), findsOneWidget);
      expect(find.byType(WebViewPayment), findsNothing);
    });

    testWidgets('intercepts the success url and blocks the navigation', (
      tester,
    ) async {
      // Act
      await pumpPayment(tester);
      final decision = await fakePlatform.lastDelegate.navigate(successUrl);
      await pumpFrames(tester);

      // Assert
      expect(decision, NavigationDecision.prevent);
      expect(find.text(orderSuccessRoute), findsOneWidget);
      expect(find.byType(WebViewPayment), findsNothing);
    });

    testWidgets('intercepts the cancel url and blocks the navigation', (
      tester,
    ) async {
      // Act
      await pumpPayment(tester);
      final decision = await fakePlatform.lastDelegate.navigate(cancelUrl);
      await pumpFrames(tester);

      // Assert
      expect(decision, NavigationDecision.prevent);
      expect(find.text(checkoutRoute), findsOneWidget);
      expect(find.byType(WebViewPayment), findsNothing);
    });

    testWidgets('leaves unrelated urls to the web view', (tester) async {
      // Act
      await pumpPayment(tester);
      final decision = await fakePlatform.lastDelegate.navigate(
        'https://example.com/checkout',
      );

      // Assert
      expect(decision, NavigationDecision.navigate);
      expect(find.byType(WebViewPayment), findsOneWidget);
      expect(find.text(orderSuccessRoute), findsNothing);
      expect(find.text(checkoutRoute), findsNothing);
    });

    testWidgets('ignores a success url once the screen is gone', (
      tester,
    ) async {
      // Arrange
      await pumpPayment(tester);
      final handleNavigation = fakePlatform.lastDelegate.onNavigationRequest!;

      // Act
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      final decision = await handleNavigation(
        const NavigationRequest(url: successUrl, isMainFrame: true),
      );

      // Assert
      expect(decision, NavigationDecision.prevent);
      expect(find.byType(WebViewPayment), findsNothing);
      expect(find.text(orderSuccessRoute), findsNothing);
    });
  });
}
