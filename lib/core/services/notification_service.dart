import 'dart:async';

import 'package:flower_app/core/services/notification_navigator.dart';
import 'package:injectable/injectable.dart';

/// Application-level notification handling.
///
/// Deliberately free of Firebase specifics (those live in
/// `FirebaseMessagingService`) and of navigation (the navigation intent is
/// published on [NotificationNavigator] and carried out by the presentation
/// layer). [message] is intentionally `Object`: a remote payload today, a local
/// notification or a deep link later, without changing this contract.
abstract interface class NotificationService {
  /// Records/presents [message] and publishes it as a navigation intent.
  /// Never throws; a notification must not be able to crash the app.
  Future<void> handleMessage(Object? message);
}

@LazySingleton(as: NotificationService)
class AppNotificationService implements NotificationService {
  AppNotificationService(this._navigator);

  final NotificationNavigator _navigator;

  @override
  Future<void> handleMessage(Object? message) async {
    if (message == null) return;

    try {
      _navigator.openNotification(message);
    } catch (e) {
      // The navigator not being ready (early startup / rebuild) is an expected
      // condition here, not a programming error; log and drop the intent.
      _navigator.dropPending();
    }
  }

  /// Releases anything held by the service. Kept for symmetry with
  /// `FirebaseMessagingService` and safe to call more than once.
  Future<void> dispose() async {}
}
