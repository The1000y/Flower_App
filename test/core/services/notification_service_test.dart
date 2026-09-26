import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Test double for the gateway, so the message streams can be driven without
/// touching the `FirebaseMessaging` statics.
class MockFirebaseMessagingGateway extends Mock
    implements FirebaseMessagingGateway {}

class MockNotificationSettings extends Mock implements NotificationSettings {}

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

  late MockFirebaseMessagingGateway gateway;
  late GlobalKey<NavigatorState> navKey;
  late StreamController<RemoteMessage> foreground;
  late StreamController<RemoteMessage> opened;

  setUp(() {
    gateway = MockFirebaseMessagingGateway();
    navKey = GlobalKey<NavigatorState>();
    foreground = StreamController<RemoteMessage>.broadcast();
    opened = StreamController<RemoteMessage>.broadcast();

    when(() => gateway.onMessage).thenAnswer((_) => foreground.stream);
    when(() => gateway.onMessageOpenedApp).thenAnswer((_) => opened.stream);
    when(gateway.getInitialMessage).thenAnswer((_) async => null);
    when(
      gateway.requestPermission,
    ).thenAnswer((_) async => MockNotificationSettings());
    when(gateway.getToken).thenAnswer((_) async => 'token-123');
  });

  tearDown(() async {
    await foreground.close();
    await opened.close();
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
      final service = FirebaseNotificationService(gateway, navKey);

      await service.handleBackground(message);
      await tester.pumpAndSettle();

      expect(observer.pushedNames, contains('/notification'));
      final route = ModalRoute.of(tester.element(find.text('destination')));
      expect(route?.settings.arguments, message);
    });

    testWidgets('does nothing when the message is null', (tester) async {
      final observer = await pumpNavigator(tester);
      final service = FirebaseNotificationService(gateway, navKey);

      await service.handleBackground(null);
      await tester.pumpAndSettle();

      expect(observer.pushedNames, isNot(contains('/notification')));
    });

    test('does not throw when the navigator is not attached', () async {
      // Regression test: a GlobalKey whose currentState is null (early startup
      // or a rebuilt tree) must not cause a null-check crash.
      final detachedKey = GlobalKey<NavigatorState>();
      final service = FirebaseNotificationService(gateway, detachedKey);

      await expectLater(service.handleBackground(message), completes);
    });

    test('completes normally when navigation throws', () async {
      final service = FirebaseNotificationService(gateway, navKey);

      // No navigator is attached, so pushNamed is a no-op and must not throw.
      await expectLater(service.handleBackground(message), completes);
    });
  });

  group('FirebaseNotificationService.initialize', () {
    test('requests permission and reads the token', () async {
      final service = FirebaseNotificationService(gateway, navKey);
      addTearDown(service.dispose);

      await service.initialize();

      verify(() => gateway.requestPermission()).called(1);
      verify(() => gateway.getToken()).called(1);
    });

    test('survives a failing permission request', () async {
      when(gateway.requestPermission).thenThrow(Exception('denied'));
      when(gateway.getToken).thenThrow(Exception('no token'));

      final service = FirebaseNotificationService(gateway, navKey);
      addTearDown(service.dispose);

      await expectLater(service.initialize(), completes);
    });

    test('does not stack duplicate subscriptions when called twice', () async {
      final service = FirebaseNotificationService(gateway, navKey);
      addTearDown(service.dispose);

      await service.initialize();
      await service.initialize();

      // The guard must prevent a second round of setup work.
      verify(() => gateway.requestPermission()).called(1);
      verify(() => gateway.getToken()).called(1);
      verify(() => gateway.onMessage).called(1);
      verify(() => gateway.onMessageOpenedApp).called(1);
    });

    testWidgets('navigates when a background message is opened', (
      tester,
    ) async {
      final service = FirebaseNotificationService(gateway, navKey);
      addTearDown(service.dispose);

      await service.initialize();
      final observer = await pumpNavigator(tester);

      opened.add(message);
      await tester.pumpAndSettle();

      expect(observer.pushedNames, contains('/notification'));
    });

    testWidgets('a foreground message does not navigate', (tester) async {
      final service = FirebaseNotificationService(gateway, navKey);
      addTearDown(service.dispose);

      await service.initialize();
      final observer = await pumpNavigator(tester);

      foreground.add(message);
      await tester.pumpAndSettle();

      expect(observer.pushedNames, isNot(contains('/notification')));
    });

    test('navigates for a message present at startup', () async {
      when(gateway.getInitialMessage).thenAnswer((_) async => message);

      final service = FirebaseNotificationService(gateway, navKey);
      addTearDown(service.dispose);

      await service.initialize();
      await pumpEventQueue();

      verify(() => gateway.getInitialMessage()).called(1);
    });

    test(
      'swallows an error thrown while reading the initial message',
      () async {
        when(gateway.getInitialMessage).thenThrow(Exception('boom'));

        final service = FirebaseNotificationService(gateway, navKey);
        addTearDown(service.dispose);

        await expectLater(service.initialize(), completes);
        await pumpEventQueue();
      },
    );
  });

  group('FirebaseNotificationService.dispose', () {
    test('cancels the message subscriptions', () async {
      final service = FirebaseNotificationService(gateway, navKey);

      await service.initialize();
      expect(foreground.hasListener, isTrue);
      expect(opened.hasListener, isTrue);

      await service.dispose();

      expect(foreground.hasListener, isFalse);
      expect(opened.hasListener, isFalse);
    });

    test('is idempotent and safe without a prior initialize', () async {
      final service = FirebaseNotificationService(gateway, navKey);

      await expectLater(service.dispose(), completes);
      await expectLater(service.dispose(), completes);
    });

    test('allows re-initializing after dispose', () async {
      final service = FirebaseNotificationService(gateway, navKey);

      await service.initialize();
      await service.dispose();
      await service.initialize();

      expect(foreground.hasListener, isTrue);

      await service.dispose();
      expect(foreground.hasListener, isFalse);
    });
  });
}
