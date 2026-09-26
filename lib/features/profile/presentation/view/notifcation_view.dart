import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/notification_item.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Single-notification screen.
///
/// [message] is nullable so callers (routes, notification service) can open
/// the screen without a payload; the empty state is rendered here rather than
/// by constructing a synthetic `RemoteMessage` at the call site.
class NotifcationView extends StatelessWidget {
  const NotifcationView({super.key, this.message});

  final RemoteMessage? message;

  @override
  Widget build(BuildContext context) {
    final notification = message?.notification;
    final l10n = AppLocalizations.of(context)!;
    final hasNotification = notification != null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationTitle)),
      body: hasNotification
          ? NotificationItem(
              title: notification.title ?? l10n.notificationTitle,
              body: notification.body ?? '',
            )
          : Center(
              child: Text(
                l10n.noNotificationsYet,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}
