import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

/// Instance-level view of the FirebaseMessaging surface this app depends on.
///
/// `FirebaseMessaging.onMessage` / `onMessageOpenedApp` are static-only getters
/// on the plugin, so they cannot be swapped in a test. This gateway wraps them
/// behind instance members, letting [FirebaseMessagingService] take a single
/// injectable collaborator and keeping the plugin statics confined to this file.
abstract interface class FirebaseMessagingGateway {
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
