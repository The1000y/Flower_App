import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

/// Instance-level view of the message streams we depend on.
///
/// `FirebaseMessaging.onMessage` / `onMessageOpenedApp` are static-only getters
/// on the plugin, so they cannot be swapped in a test. This gateway wraps them
/// behind instance members, letting [FirebaseNotificationService] take a single
/// injectable collaborator and keeping the statics confined to one file.
abstract class FirebaseMessagingGateway {
  Stream<RemoteMessage> get onMessage;

  Stream<RemoteMessage> get onMessageOpenedApp;

  Future<RemoteMessage?> getInitialMessage();

  Future<NotificationSettings> requestPermission();

  Future<String?> getToken();
}

@LazySingleton(as: FirebaseMessagingGateway)
class FirebaseMessagingGatewayImpl implements FirebaseMessagingGateway {
  FirebaseMessagingGatewayImpl(this._messaging);

  final FirebaseMessaging _messaging;

  @override
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  @override
  Future<RemoteMessage?> getInitialMessage() => _messaging.getInitialMessage();

  @override
  Future<NotificationSettings> requestPermission() =>
      _messaging.requestPermission(alert: true, badge: true, sound: true);

  @override
  Future<String?> getToken() => _messaging.getToken();
}

abstract class NotificationService {
  Future<void> initialize();

  Future<void> handleBackground(RemoteMessage? message);

  /// Releases the stream subscriptions held by [initialize]. Safe to call more
  /// than once; implementations must make it idempotent.
  Future<void> dispose();
}

@LazySingleton(as: NotificationService)
class FirebaseNotificationService implements NotificationService {
  FirebaseNotificationService(this._gateway, this._navKey);

  final FirebaseMessagingGateway _gateway;
  final GlobalKey<NavigatorState> _navKey;

  final List<StreamSubscription<RemoteMessage>> _subscriptions = [];

  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      await _gateway.requestPermission();
      final token = await _gateway.getToken();
      debugPrint('FCM Token: $token');
    } catch (e) {
      debugPrint('Error requesting FCM permission/token: $e');
    }

    // Subscriptions are retained so [dispose] can cancel them; re-initializing
    // without a dispose would otherwise stack duplicate listeners.
    _subscriptions.add(_gateway.onMessage.listen(_onForegroundMessage));
    _subscriptions.add(
      _gateway.onMessageOpenedApp.listen(
        (message) => unawaited(handleBackground(message)),
      ),
    );

    unawaited(_handleInitialMessage());
  }

  /// Reads the message that launched the app, if any.
  ///
  /// Wrapped in its own try/catch because `getInitialMessage` can throw
  /// *synchronously* (e.g. a plugin-side platform error), which a
  /// `Future.catchError` chained on the returned future would never see and
  /// would therefore escape as an unhandled error.
  Future<void> _handleInitialMessage() async {
    try {
      await handleBackground(await _gateway.getInitialMessage());
    } catch (e) {
      debugPrint('Error reading initial message: $e');
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    // TODO: Show a local notification or in-app banner if needed.
    debugPrint('Foreground message: ${message.messageId}');
  }

  @override
  Future<void> handleBackground(RemoteMessage? message) async {
    if (message == null) return;

    try {
      // The navigator may not be attached yet (early startup / rebuild), so the
      // current state is dereferenced safely instead of force-unwrapped.
      // `pushNamed` completes when the pushed route is *popped*, so its future
      // is intentionally not awaited here.
      unawaited(
        _navKey.currentState?.pushNamed(
              Routes.notification,
              arguments: message,
            ) ??
            Future<void>.value(),
      );
    } catch (e) {
      debugPrint('Error handling background message: $e');
    }
  }

  @override
  Future<void> dispose() async {
    _initialized = false;

    final subscriptions = List<StreamSubscription<RemoteMessage>>.from(
      _subscriptions,
    );
    _subscriptions.clear();

    for (final subscription in subscriptions) {
      await subscription.cancel();
    }
  }
}
