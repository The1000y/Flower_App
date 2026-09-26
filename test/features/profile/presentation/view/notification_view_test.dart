import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/features/profile/presentation/view/notifcation_view.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/notification_item.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('NotifcationView renders notification title and content', (tester) async {
    const message = RemoteMessage(
      notification: RemoteNotification(
        title: 'Special Discount',
        body: 'Special spring collection discount is live!',
      ),
    );

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: NotifcationView(message: message),
      ),
    );

    expect(find.text('Notification'), findsOneWidget);
    expect(find.byType(NotificationItem), findsOneWidget);
    expect(find.text('Special Discount'), findsOneWidget);
    expect(find.text('Special spring collection discount is live!'), findsOneWidget);
  });
}
