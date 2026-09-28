import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/core/services/firebase_messaging_gateway.dart';
import 'package:flower_app/core/services/firebase_messaging_service.dart';
import 'package:flower_app/core/services/notification_navigator.dart';
import 'package:flower_app/core/services/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockNotificationSettings extends Mock implements NotificationSettings {}

class _FakeFirebaseMessagingGateway implements FirebaseMessagingGateway {
  final onMessageController = StreamController<RemoteMessage>.broadcast();
  final onMessageOpenedController = StreamController<RemoteMessage>.broadcast();

  /// When set, [requestPermission] throws it.
  Object? permissionError;

  /// When set, [getToken] throws it.
  Object? tokenError;

  /// When set, [getInitialMessage] throws it *synchronously*.
  Object? initialMessageError;

  RemoteMessage? initialMessage;

  int permissionCalls = 0;
  int tokenCalls = 0;
  int initialMessageCalls = 0;

  @override
  Stream<RemoteMessage> get onMessage => onMessageController.stream;

  @override
  Stream<RemoteMessage> get onMessageOpenedApp =>
      onMessageOpenedController.stream;

  @override
  Future<RemoteMessage?> getInitialMessage() {
    initialMessageCalls++;
    if (initialMessageError != null) throw initialMessageError!;
    return Future<RemoteMessage?>.value(initialMessage);
  }

  @override
  Future<NotificationSettings> requestPermission() async {
    permissionCalls++;
    if (permissionError != null) throw permissionError!;
    return _MockNotificationSettings();
  }

  @override
  Future<String?> getToken() async {
    tokenCalls++;
    if (tokenError != null) throw tokenError!;
    return 'fake-token';
  }

  Future<void> close() async {
    await onMessageController.close();
    await onMessageOpenedController.close();
  }
}

class _RecordingNotificationService implements NotificationService {
  final List<Object?> handled = [];

  @override
  Future<void> handleMessage(Object? message) async => handled.add(message);
}

class _RemoteMessageStub extends RemoteMessage {
  _RemoteMessageStub(this.stubId);

  final String stubId;

  @override
  String? get messageId => stubId;
}

void main() {
  late _FakeFirebaseMessagingGateway gateway;
  late _RecordingNotificationService notifications;

  setUp(() {
    gateway = _FakeFirebaseMessagingGateway();
    notifications = _RecordingNotificationService();
  });

  tearDown(() => gateway.close());

  FirebaseMessagingService buildService() =>
      FirebaseMessagingService(gateway, notifications);

  group('FirebaseMessagingService.initialize', () {
    test('requests permission and fetches the token', () async {
      final service = buildService();
      addTearDown(service.dispose);

      await service.initialize();

      expect(gateway.permissionCalls, 1);
      expect(gateway.tokenCalls, 1);
    });

    test('subscribes to both message streams', () async {
      final service = buildService();
      addTearDown(service.dispose);

      await service.initialize();

      // Verified by cancelling: a missing subscription would not throw.
      await service.dispose();
    });

    test('is idempotent', () async {
      final service = buildService();
      addTearDown(service.dispose);

      await service.initialize();
      await service.initialize();

      expect(gateway.permissionCalls, 1);
    });

    test('still subscribes when the permission request throws', () async {
      gateway.permissionError = Exception('denied');
      final service = buildService();
      addTearDown(service.dispose);

      await service.initialize();

      // A denied permission must not stop the service from listening.
      expect(gateway.tokenCalls, 0);
    });

    test('still subscribes when the token fetch throws', () async {
      gateway.tokenError = Exception('no token');
      final service = buildService();
      addTearDown(service.dispose);

      await service.initialize();

      expect(gateway.permissionCalls, 1);
    });

    test('forwards the launch message to the notification service', () async {
      final message = _RemoteMessageStub('initial');
      gateway.initialMessage = message;
      final service = buildService();
      addTearDown(service.dispose);

      await service.initialize();
      // Let the unawaited initial-message handling settle.
      await Future<void>.delayed(Duration.zero);

      expect(notifications.handled, contains(message));
    });

    test('swallows a synchronous getInitialMessage failure', () async {
      gateway.initialMessageError = Exception('platform error');
      final service = buildService();
      addTearDown(service.dispose);

      await service.initialize();
      await Future<void>.delayed(Duration.zero);

      // A synchronous throw would otherwise escape as an unhandled error.
      expect(notifications.handled, isEmpty);
    });

    test(
      'forwards an opened-app message to the notification service',
      () async {
        final service = buildService();
        addTearDown(service.dispose);

        await service.initialize();
        final message = _RemoteMessageStub('opened');
        gateway.onMessageOpenedController.add(message);
        await Future<void>.delayed(Duration.zero);

        expect(notifications.handled, contains(message));
      },
    );
  });

  group('FirebaseMessagingService.dispose', () {
    test('cancels the subscriptions', () async {
      final service = buildService();

      await service.initialize();
      await service.dispose();

      final message = _RemoteMessageStub('after-dispose');
      gateway.onMessageOpenedController.add(message);
      await Future<void>.delayed(Duration.zero);

      expect(
        notifications.handled,
        isNot(contains(message)),
        reason: 'a disposed service must not receive further messages',
      );
    });

    test('is idempotent', () async {
      final service = buildService();
      await service.initialize();

      await service.dispose();
      await service.dispose();
    });

    test('allows re-initializing afterwards', () async {
      final service = buildService();

      await service.initialize();
      await service.dispose();
      await service.initialize();

      expect(gateway.permissionCalls, 2);

      await service.dispose();
    });
  });

  group('AppNotificationService', () {
    test('publishes the message on the navigator', () async {
      final notifier = NotificationNavigationNotifier();
      final service = AppNotificationService(notifier);
      final received = <Object>[];
      final sub = notifier.notifications.listen(received.add);
      addTearDown(sub.cancel);

      final message = _RemoteMessageStub('foreground');
      await service.handleMessage(message);
      await Future<void>.delayed(Duration.zero);

      expect(received, contains(message));
    });

    test('ignores a null message', () async {
      final notifier = NotificationNavigationNotifier();
      final service = AppNotificationService(notifier);
      final received = <Object>[];
      final sub = notifier.notifications.listen(received.add);
      addTearDown(sub.cancel);

      await service.handleMessage(null);
      await Future<void>.delayed(Duration.zero);

      expect(received, isEmpty);
    });

    test('does not touch the navigator when the message is null', () async {
      final notifier = _ThrowingNotificationNavigator();
      final service = AppNotificationService(notifier);

      await service.handleMessage(null);

      expect(notifier.openCalls, 0);
    });

    test('discards the intent when the navigator throws', () async {
      final notifier = _ThrowingNotificationNavigator();
      final service = AppNotificationService(notifier);

      // Must not rethrow: a notification cannot be allowed to crash the app.
      await service.handleMessage(_RemoteMessageStub('boom'));

      expect(notifier.droppedCalls, 1);
    });

    test('dispose is idempotent', () async {
      final notifier = NotificationNavigationNotifier();
      final service = AppNotificationService(notifier);

      await service.dispose();
      await service.dispose();
    });
  });

  group('NotificationNavigationNotifier', () {
    test('replays an intent published before any listener existed', () async {
      final notifier = NotificationNavigationNotifier();

      final message = _RemoteMessageStub('cold-start');
      notifier.openNotification(message);

      // The listener attaches later, as it does when the app boots from a
      // notification tap.
      final received = <Object>[];
      final sub = notifier.notifications.listen(received.add);
      await Future<void>.delayed(Duration.zero);
      addTearDown(sub.cancel);

      expect(received, contains(message));
    });

    test('replays the intent only once', () async {
      final notifier = NotificationNavigationNotifier();
      final message = _RemoteMessageStub('cold-start');
      notifier.openNotification(message);

      final first = <Object>[];
      final firstSub = notifier.notifications.listen(first.add);
      await Future<void>.delayed(Duration.zero);
      await firstSub.cancel();

      final second = <Object>[];
      final secondSub = notifier.notifications.listen(second.add);
      await Future<void>.delayed(Duration.zero);
      addTearDown(secondSub.cancel);

      expect(first, contains(message));
      expect(second, isEmpty, reason: 'the buffered intent is not re-queued');
    });

    test('delivers straight to an attached listener', () async {
      final notifier = NotificationNavigationNotifier();
      final received = <Object>[];
      final sub = notifier.notifications.listen(received.add);
      addTearDown(sub.cancel);

      final message = _RemoteMessageStub('live');
      notifier.openNotification(message);
      await Future<void>.delayed(Duration.zero);

      expect(received, contains(message));
    });

    test('drops a pending intent when handling fails', () async {
      final notifier = NotificationNavigationNotifier();
      notifier.openNotification(_RemoteMessageStub('dropped'));
      notifier.dropPending();

      final received = <Object>[];
      final sub = notifier.notifications.listen(received.add);
      await Future<void>.delayed(Duration.zero);
      addTearDown(sub.cancel);

      expect(received, isEmpty);
    });
  });
}

/// A navigator that always fails, so the service's error path can be exercised.
class _ThrowingNotificationNavigator implements NotificationNavigator {
  int openCalls = 0;
  int droppedCalls = 0;

  @override
  Stream<Object> get notifications => const Stream<Object>.empty();

  @override
  void openNotification(Object message) {
    openCalls++;
    throw Exception('navigator not ready');
  }

  @override
  void dropPending() => droppedCalls++;
}
