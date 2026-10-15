import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/core/services/firebase_messaging_gateway.dart';
import 'package:flower_app/core/services/firebase_update_messaging_service.dart';
import 'package:flower_app/core/services/notification_service.dart';
import 'package:flower_app/core/services/order_update_message.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Firebase Cloud Messaging only: permissions, the device token, and the
/// platform message streams.
///
/// This class knows nothing about routes, navigators or the UI. It translates
/// platform events into application-level [NotificationService] calls, which
/// keeps the Firebase-specific half and the app-level half independently
/// testable.
@lazySingleton
class FirebaseMessagingService {
  FirebaseMessagingService(
    this._gateway,
    this._notificationService,
    this._updateMessagingService,
  );

  final FirebaseMessagingGateway _gateway;
  final NotificationService _notificationService;
  final FirebaseUpdateMessagingService _updateMessagingService;

  final List<StreamSubscription<RemoteMessage>> _subscriptions = [];

  bool _initialized = false;

  /// Requests permission, fetches the token and starts listening. Safe to call
  /// more than once; a second call is a no-op until [dispose].
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
        (message) => unawaited(_routeMessage(message)),
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
      final message = await _gateway.getInitialMessage();
      if (message == null) return;
      await _routeMessage(message);
    } catch (e) {
      debugPrint('Error reading initial message: $e');
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    final update = OrderUpdateMessage.tryParse(message);
    if (update != null) {
      unawaited(_updateMessagingService.handle(update));
      return;
    }
    debugPrint('Foreground message: ${message.messageId}');
  }

  Future<void> _routeMessage(RemoteMessage message) async {
    final update = OrderUpdateMessage.tryParse(message);
    if (update != null) {
      await _updateMessagingService.handle(update);
      return;
    }
    await _notificationService.handleMessage(message);
  }

  /// Releases the stream subscriptions held by [initialize]. Safe to call more
  /// than once.
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
