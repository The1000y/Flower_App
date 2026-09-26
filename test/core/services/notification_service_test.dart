import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class _FakeNavigatorObserver extends NavigatorObserver {
  final List<String?> pushedNames = <String?>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedNames.add(route.settings.name);
    super.didPush(route, previousRoute);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseMessaging messaging;
  late GlobalKey<NavigatorState> navKey;

  setUp(() {
    messaging = MockFirebaseMessaging();
    navKey = GlobalKey<NavigatorState>();
  });

  /// Pumps a navigator owning [navKey] so `currentState` is attached.
  Future<_FakeNavigatorObserver> pumpNavigator(WidgetTester tester) async {
    final observer = _FakeNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navKey,
        navigatorObservers: [observer],
        onGenerateRoute: (settings) => MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const Scaffold(body: Text('destination')),
        ),
      ),
    );
    return observer;
  }

  const message = RemoteMessage(
    notification: RemoteNotification(title: 'Hi', body: 'There'),
  );

  group('FirebaseNotificationService.handleBackground', () {
    testWidgets('pushes the notification route with the message arguments', (
      tester,
    ) async {
      final observer = await pumpNavigator(tester);
      final service = FirebaseNotificationService(messaging, navKey);

      await service.handleBackground(message);
      await tester.pumpAndSettle();

      expect(observer.pushedNames, contains('/notification'));
      final route = ModalRoute.of(tester.element(find.text('destination')));
      expect(route?.settings.arguments, message);
    });

    testWidgets('does nothing when the message is null', (tester) async {
      final observer = await pumpNavigator(tester);
      final service = FirebaseNotificationService(messaging, navKey);

      await service.handleBackground(null);
      await tester.pumpAndSettle();

      expect(observer.pushedNames, isNot(contains('/notification')));
    });

    test('does not throw when the navigator is not attached', () async {
      // Regression test: a GlobalKey whose currentState is null (early startup
      // or a rebuilt tree) must not cause a null-check crash.
      final detachedKey = GlobalKey<NavigatorState>();
      final service = FirebaseNotificationService(messaging, detachedKey);

      await expectLater(service.handleBackground(message), completes);
    });

    test('completes normally when navigation throws', () async {
      final service = FirebaseNotificationService(messaging, navKey);

      // No navigator is attached, so pushNamed is a no-op and must not throw.
      await expectLater(service.handleBackground(message), completes);
    });
  });
}
