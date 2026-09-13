import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/notification_item.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class NotifcationView extends StatelessWidget {
  const NotifcationView({
    super.key,
    required this.message,
  });

  final RemoteMessage message;

  @override
  Widget build(BuildContext context) {
    final notification = message.notification;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationTitle),
      ),
      body: NotificationItem(
        title: notification?.title ?? '',
        body: notification?.body ?? '',
      ),
    );
  }
}