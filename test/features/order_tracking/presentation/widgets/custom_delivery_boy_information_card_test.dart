import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_contract_card.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_delivery_boy_information_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/order_tracking_test_helpers.dart';

const _imageUrl = 'https://example.com/delivery-boy.jpg';

Widget _card({
  String name = 'Mohamed',
  String phone = '01014194042',
  String imageUrl = _imageUrl,
}) {
  return CustomDeliveryBoyInformationCard(
    deliveryBoyName: name,
    deliveryBoyPhoneNumber: phone,
    deliveryBoyImageURL: imageUrl,
  );
}

void main() {
  group('CustomDeliveryBoyInformationCard', () {
    testWidgets('shows the delivery boy name', (tester) async {
      await pumpOrderTrackingApp(tester, _card(name: 'Mohamed'));

      expect(find.text('Mohamed'), findsOneWidget);
    });

    testWidgets('shows the "delivery hero" subtitle', (tester) async {
      await pumpOrderTrackingApp(tester, _card());

      expect(find.text(AppStrings.deliveryHeroSubtitle), findsOneWidget);
    });

    testWidgets('shows a different name when another one is passed in', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _card(name: 'Ahmed'));

      expect(find.text('Ahmed'), findsOneWidget);
      expect(find.text('Mohamed'), findsNothing);
    });

    testWidgets('name sits above the subtitle', (tester) async {
      await pumpOrderTrackingApp(tester, _card());

      expect(
        tester.getTopLeft(find.text('Mohamed')).dy,
        lessThan(tester.getTopLeft(find.text(AppStrings.deliveryHeroSubtitle)).dy),
      );
    });
  });

  group('CustomDeliveryBoyInformationCard - avatar', () {
    testWidgets('uses a 50px pink circular avatar', (tester) async {
      await pumpOrderTrackingApp(tester, _card());

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.radius, 25);
      expect(avatar.backgroundColor, AppColors.pinkBase);
    });

    testWidgets('loads the picture from the given url', (tester) async {
      await pumpOrderTrackingApp(tester, _card());

      final image = tester.widget<Image>(
        find.descendant(
          of: find.byType(CircleAvatar),
          matching: find.byType(Image),
        ),
      );
      expect(image.image, isA<NetworkImage>());
      expect((image.image as NetworkImage).url, _imageUrl);
      expect(image.width, 50);
      expect(image.height, 50);
      expect(image.fit, BoxFit.cover);
    });

    // flutter_test answers every HTTP request with status 400, so the network
    // image always fails here and the app's errorBuilder fallback is shown.
    testWidgets('falls back to a person icon when the picture cannot load', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _card());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });

  group('CustomDeliveryBoyInformationCard - contact buttons', () {
    testWidgets('includes the contact card with the delivery boy phone number', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _card(phone: '01234567890'));

      final contact = tester.widget<CustomContactCard>(
        find.byType(CustomContactCard),
      );
      expect(contact.phoneNumber, '01234567890');
    });

    testWidgets('offers two buttons: call and WhatsApp', (tester) async {
      await pumpOrderTrackingApp(tester, _card());

      expect(
        find.descendant(
          of: find.byType(CustomContactCard),
          matching: find.byType(IconButton),
        ),
        findsNWidgets(2),
      );
    });

    testWidgets('contact buttons are placed after the name column', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _card());

      expect(
        tester.getTopLeft(find.byType(CustomContactCard)).dx,
        greaterThan(tester.getTopLeft(find.text('Mohamed')).dx),
      );
    });
  });
}
