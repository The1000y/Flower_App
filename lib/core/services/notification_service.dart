import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class NotificationService {
  Future<void> initialize();

  Future<void> handleBackground(RemoteMessage? message);
}

@LazySingleton(as: NotificationService)
class FirebaseNotificationService implements NotificationService {
  final FirebaseMessaging _messaging;
  final GlobalKey<NavigatorState> _navKey;

  FirebaseNotificationService(this._messaging, this._navKey);

  @override
  Future<void> initialize() async {
    try {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
      final token = await _messaging.getToken();
      debugPrint('FCM Token: $token');
    } catch (e) {
      debugPrint('Error requesting FCM permission/token: $e');
    }

    // Foreground messages.
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Messages delivered while the app is in the background or terminated.
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => unawaited(handleBackground(message)),
    );
    unawaited(
      _messaging
          .getInitialMessage()
          .then(handleBackground)
          .catchError(
            (Object e) => debugPrint('Error reading initial message: $e'),
          ),
    );
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
}
