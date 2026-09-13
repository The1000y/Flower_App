import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:injectable/injectable.dart';
@injectable
class NotifcationView extends StatelessWidget {
  const NotifcationView({
    super.key,
    required this.message,
  });

  final RemoteMessage message;

  @override
  Widget build(BuildContext context) {
    final notification = message.notification;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.notificationTitle),
      ),
      body: NotificationItem(
        title: notification?.title ?? '',
        body: notification?.body ?? '',
      ),
    );
  }
}