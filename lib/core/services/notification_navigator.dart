import 'dart:async';

import 'package:injectable/injectable.dart';

/// Publishes "the user should open this notification" intents.
///
/// The presentation layer is the only thing that knows how to navigate, so the
/// notification pipeline never holds a `Navigator` or a `GlobalKey`; it hands
/// the intent over here instead.
abstract interface class NotificationNavigator {
  /// The stream of pending intents. A single buffered event is replayed to the
  /// first listener, so an intent published before the UI exists is not lost.
  Stream<Object> get notifications;

  /// Publishes [message] as an intent to open the notification screen.
  void openNotification(Object message);

  /// Discards the buffered intent, used when handling failed.
  void dropPending();
}

@LazySingleton(as: NotificationNavigator)
class NotificationNavigationNotifier implements NotificationNavigator {
  NotificationNavigationNotifier() {
    // Assigned here rather than in a field initializer because a controller
    // initializer cannot reference an instance member.
    _controller.onListen = _replayPending;
  }

  final StreamController<Object> _controller =
      StreamController<Object>.broadcast();

  Object? _pending;

  @override
  Stream<Object> get notifications => _controller.stream;

  @override
  void openNotification(Object message) {
    if (_controller.isClosed) return;

    // A listener is already attached (the app is running), so the intent is
    // delivered straight away. Otherwise it is buffered for the first
    // listener, which covers a notification that launched the app.
    if (_controller.hasListener) {
      _controller.add(message);
    } else {
      _pending = message;
    }
  }

  @override
  void dropPending() => _pending = null;

  void _replayPending() {
    final message = _pending;
    if (message == null) return;

    _pending = null;
    // Scheduled so the listener's own subscription is fully in place before the
    // event is delivered, and off the caller's stack.
    scheduleMicrotask(() {
      if (!_controller.isClosed) _controller.add(message);
    });
  }
}
