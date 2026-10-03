import 'package:flower_app/features/profile/presentation/view/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('NotificationItem displays title and body correctly', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NotificationItem(
            title: '50% Discount Offer',
            body: 'Get 50% discount on all spring bouquets today!',
          ),
        ),
      ),
    );

    expect(find.text('50% Discount Offer'), findsOneWidget);
    expect(
      find.text('Get 50% discount on all spring bouquets today!'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.notifications_none_outlined), findsOneWidget);
  });
}
