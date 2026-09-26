import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/features/profile/presentation/view/notifcation_view.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/notification_item.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }

  group('NotifcationView', () {
    testWidgets('renders the notification title and body', (tester) async {
      const message = RemoteMessage(
        notification: RemoteNotification(
          title: 'Special Discount',
          body: 'Special spring collection discount is live!',
        ),
      );

      await tester.pumpWidget(wrap(const NotifcationView(message: message)));

      expect(find.byType(NotificationItem), findsOneWidget);
      expect(find.text('Special Discount'), findsOneWidget);
      expect(
        find.text('Special spring collection discount is live!'),
        findsOneWidget,
      );
    });

    testWidgets('renders the app bar title', (tester) async {
      const message = RemoteMessage(
        notification: RemoteNotification(title: 'Hi', body: 'There'),
      );

      await tester.pumpWidget(wrap(const NotifcationView(message: message)));

      expect(find.widgetWithText(AppBar, 'Notification'), findsOneWidget);
    });

    testWidgets('falls back to the notification title when title is null', (
      tester,
    ) async {
      const message = RemoteMessage(
        notification: RemoteNotification(body: 'Body only'),
      );

      await tester.pumpWidget(wrap(const NotifcationView(message: message)));

      expect(find.text('Notification'), findsWidgets);
      expect(find.text('Body only'), findsOneWidget);
    });

    testWidgets('renders an empty body when it is null', (tester) async {
      const message = RemoteMessage(
        notification: RemoteNotification(title: 'Title only'),
      );

      await tester.pumpWidget(wrap(const NotifcationView(message: message)));

      expect(find.text('Title only'), findsOneWidget);
    });

    testWidgets('shows the empty state when the message is null', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const NotifcationView()));

      expect(find.byType(NotificationItem), findsNothing);
      expect(find.text('No notifications yet'), findsOneWidget);
    });

    testWidgets('shows the empty state when the message has no notification', (
      tester,
    ) async {
      const message = RemoteMessage(data: <String, dynamic>{'k': 'v'});

      await tester.pumpWidget(wrap(const NotifcationView(message: message)));

      expect(find.byType(NotificationItem), findsNothing);
      expect(find.text('No notifications yet'), findsOneWidget);
    });
  });
}
