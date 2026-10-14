import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_contract_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../../../helpers/order_tracking_test_helpers.dart';

/// Replaces the real url_launcher platform so no native call is made and we can
/// see exactly which urls the buttons try to open.
class _FakeUrlLauncher extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  _FakeUrlLauncher({this.canLaunchResult = true});

  final bool canLaunchResult;
  final List<String> checkedUrls = [];
  final List<String> launchedUrls = [];
  final List<LaunchOptions> launchOptions = [];

  @override
  Future<bool> canLaunch(String url) async {
    checkedUrls.add(url);
    return canLaunchResult;
  }

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrls.add(url);
    launchOptions.add(options);
    return true;
  }
}

Finder _callButton() => find.byType(IconButton).first;
Finder _whatsAppButton() => find.byType(IconButton).last;

Future<void> _pumpCard(
  WidgetTester tester, {
  String phone = '01014194042',
}) => pumpOrderTrackingApp(tester, CustomContactCard(phoneNumber: phone));

void main() {
  late _FakeUrlLauncher launcher;

  setUp(() {
    launcher = _FakeUrlLauncher();
    UrlLauncherPlatform.instance = launcher;
  });

  group('CustomContractCard - rendering', () {
    testWidgets('shows two icon buttons', (tester) async {
      await _pumpCard(tester);

      expect(find.byType(IconButton), findsNWidgets(2));
    });

    testWidgets('each button shows an svg icon', (tester) async {
      await _pumpCard(tester);

      expect(find.byType(SvgPicture), findsNWidgets(2));
    });

    testWidgets('keeps the phone number it was created with', (tester) async {
      await _pumpCard(tester, phone: '0123');

      expect(
        tester.widget<CustomContactCard>(find.byType(CustomContactCard)).phoneNumber,
        '0123',
      );
    });
  });

  group('CustomContractCard - call button', () {
    testWidgets('opens the phone dialer with a tel: link', (tester) async {
      await _pumpCard(tester, phone: '01014194042');

      await tester.tap(_callButton());
      await tester.pump();

      expect(launcher.checkedUrls, ['tel:01014194042']);
      expect(launcher.launchedUrls, ['tel:01014194042']);
    });

    testWidgets('does not touch the WhatsApp link', (tester) async {
      await _pumpCard(tester);

      await tester.tap(_callButton());
      await tester.pump();

      expect(launcher.launchedUrls.any((u) => u.contains('wa.me')), isFalse);
    });
  });

  group('CustomContractCard - WhatsApp button', () {
    testWidgets('opens the wa.me chat link for the phone number', (
      tester,
    ) async {
      await _pumpCard(tester, phone: '01014194042');

      await tester.tap(_whatsAppButton());
      await tester.pump();

      expect(launcher.launchedUrls, ['https://wa.me/01014194042']);
    });

    testWidgets('strips spaces, dashes and the plus sign from the number', (
      tester,
    ) async {
      await _pumpCard(tester, phone: '+20 101-419-4042');

      await tester.tap(_whatsAppButton());
      await tester.pump();

      expect(launcher.launchedUrls, ['https://wa.me/201014194042']);
    });

    testWidgets('opens in the external WhatsApp app, not in a web view', (
      tester,
    ) async {
      await _pumpCard(tester);

      await tester.tap(_whatsAppButton());
      await tester.pump();

      expect(
        launcher.launchOptions.single.mode,
        PreferredLaunchMode.externalApplication,
      );
    });
  });

  group('CustomContractCard - when the link cannot be opened', () {
    setUp(() {
      launcher = _FakeUrlLauncher(canLaunchResult: false);
      UrlLauncherPlatform.instance = launcher;
    });

    for (final entry in {
      'call': _callButton,
      'WhatsApp': _whatsAppButton,
    }.entries) {
      testWidgets('${entry.key}: shows the error snack bar and launches nothing', (
        tester,
      ) async {
        await _pumpCard(tester);

        await tester.tap(entry.value());
        await tester.pump(); // let the async launcher finish
        await tester.pump(const Duration(milliseconds: 750)); // snack bar in

        expect(launcher.launchedUrls, isEmpty);
        expect(find.text(AppStrings.somethingWentWrong), findsOneWidget);
        expect(
          tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
          AppColors.error,
        );
      });
    }
  });
}
