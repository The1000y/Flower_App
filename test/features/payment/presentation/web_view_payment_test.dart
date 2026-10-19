import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flower_app/features/payment/presentation/web_view_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:webview_flutter/webview_flutter.dart';

import '../../../helpers/fake_webview_platform.dart';

class MockCartCubit extends mocktail.Mock implements CartCubit {}

void main() {
  const sessionUrl = 'https://accept.paymob.com/unifiedcheckout/session';
  const successUrl = 'flowery://payment/success?orderId=order-1';
  const cancelUrl = 'flowery://payment/cancel?orderId=order-1';
  const orderId = 'order-1';
  const orderSuccessRoute = 'order-success-route';
  const previousRoute = 'previous-route';

  late FakeWebViewPlatform fakePlatform;
  late MockCartCubit cartCubit;

  setUpAll(() {
    mocktail.registerFallbackValue(ResetCartStateEvent());
  });

  setUp(() {
    fakePlatform = FakeWebViewPlatform();
    WebViewPlatform.instance = fakePlatform;
    getIt.allowReassignment = true;
    cartCubit = MockCartCubit();
    mocktail.when(() => cartCubit.stream).thenAnswer(
          (_) => const Stream.empty(),
        );
    mocktail.when(() => cartCubit.doEvent(mocktail.any())).thenAnswer(
          (_) async {},
        );
    getIt.registerSingleton<CartCubit>(cartCubit);
  });

  tearDown(() => getIt.reset());

  Future<void> pumpPayment(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          Routes.orderSuccess: (_) => const Text(orderSuccessRoute),
        },
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const WebViewPayment(
                      sessionUrl: sessionUrl,
                      successUrl: successUrl,
                      cancelUrl: cancelUrl,
                      orderId: orderId,
                    ),
                  ),
                ),
                child: const Text(previousRoute),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text(previousRoute));
    await tester.pumpAndSettle();
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

    testWidgets(
      'intercepts the success url, resets the cart and opens the success route',
      (tester) async {
        // Act
        await pumpPayment(tester);
        final decision = await fakePlatform.lastDelegate.navigate(successUrl);
        await pumpFrames(tester);

        // Assert
        expect(decision, NavigationDecision.prevent);
        expect(find.text(orderSuccessRoute), findsOneWidget);
        expect(find.byType(WebViewPayment), findsNothing);
        mocktail
            .verify(() => cartCubit.doEvent(mocktail.any()))
            .called(1);
      },
    );

    testWidgets('intercepts the cancel url and pops the screen', (
      tester,
    ) async {
      // Act
      await pumpPayment(tester);
      final decision = await fakePlatform.lastDelegate.navigate(cancelUrl);
      await pumpFrames(tester);

      // Assert
      expect(decision, NavigationDecision.prevent);
      expect(find.byType(WebViewPayment), findsNothing);
      expect(find.text(previousRoute), findsOneWidget);
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
