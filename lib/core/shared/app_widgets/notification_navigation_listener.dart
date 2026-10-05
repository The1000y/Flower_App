import 'dart:async';

import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/services/notification_navigator.dart';
import 'package:flutter/material.dart';

/// Performs the navigation requested by [NotificationNavigator].
///
/// This is the only piece of the notification pipeline that knows about
/// routes: the service publishes an intent and this widget carries it out, so
/// the service itself stays free of Flutter navigation and can be unit-tested
/// without a widget tree.
///
/// It is installed with `MaterialApp.builder`. That inserts the listener *above*
/// the root `Navigator`, so the navigator is reached through the key owned by
/// the app root rather than through this widget's own [BuildContext].
class NotificationNavigationListener extends StatefulWidget {
  const NotificationNavigationListener({
    super.key,
    required this.navigatorKey,
    required this.child,
  });

  final GlobalKey<NavigatorState> navigatorKey;

  final Widget child;

  @override
  State<NotificationNavigationListener> createState() =>
      _NotificationNavigationListenerState();
}

class _NotificationNavigationListenerState
    extends State<NotificationNavigationListener> {
  StreamSubscription<Object>? _subscription;

  @override
  void initState() {
    super.initState();

    // Subscribing here (rather than in `build`) also picks up an intent that
    // was published before this widget existed: the stream replays it to the
    // first listener.
    _subscription = getIt<NotificationNavigator>().notifications.listen(
      _openNotification,
    );
  }

  void _openNotification(Object message) {
    // The navigator may not be attached yet (early startup / rebuild), so the
    // current state is dereferenced safely instead of force-unwrapped.
    // `pushNamed` completes when the pushed route is *popped*, so its future
    // is intentionally not awaited here.
    unawaited(
      widget.navigatorKey.currentState?.pushNamed(
            Routes.notification,
            arguments: message,
          ) ??
          Future<void>.value(),
    );
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
