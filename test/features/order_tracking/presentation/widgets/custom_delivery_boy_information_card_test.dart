import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/shared/app_widgets/custom_profile_image.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_contract_card.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_delivery_boy_information_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/order_tracking_test_helpers.dart';
import 'package:flower_app/l10n/app_localizations_en.dart';

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

      expect(find.text(AppLocalizationsEn().deliveryHeroSubtitle), findsOneWidget);
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
        lessThan(tester.getTopLeft(find.text(AppLocalizationsEn().deliveryHeroSubtitle)).dy),
      );
    });
  });

  group('CustomDeliveryBoyInformationCard - avatar', () {
    testWidgets('uses a 50px rounded avatar', (tester) async {
      await pumpOrderTrackingApp(tester, _card());

      final clip = tester.widget<ClipRRect>(
        find.descendant(
          of: find.byType(CustomProfileImage),
          matching: find.byType(ClipRRect),
        ),
      );
      expect(clip.borderRadius, BorderRadius.circular(25));
    });

    testWidgets('loads the picture from the given url', (tester) async {
      await pumpOrderTrackingApp(tester, _card());

      final image = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      expect(image.imageUrl, _imageUrl);
      expect(image.width, 50);
      expect(image.height, 50);
      expect(image.fit, BoxFit.cover);
    });

    testWidgets('shows the delivery boy fallback when there is no picture', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _card(imageUrl: ''));

      expect(find.byType(CachedNetworkImage), findsNothing);
      expect(find.byType(SvgPicture), findsWidgets);
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
