import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/services/url_launcher_service.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_contract_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/order_tracking_test_helpers.dart';
import 'package:flower_app/l10n/app_localizations_en.dart';

/// Replaces the real url launcher service so no native call is made and we can
/// see exactly which urls the buttons try to open.
class _FakeUrlLauncher implements UrlLauncherService {
  _FakeUrlLauncher({this.canLaunchResult = true});

  final bool canLaunchResult;
  final List<Uri> launchedUris = [];
  final List<LaunchMode> modes = [];

  @override
  Future<bool> launch(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    if (!canLaunchResult) return false;
    launchedUris.add(uri);
    modes.add(mode);
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

  void registerLauncher(_FakeUrlLauncher value) {
    launcher = value;
    getIt.allowReassignment = true;
    getIt.registerSingleton<UrlLauncherService>(launcher);
  }

  setUp(() => registerLauncher(_FakeUrlLauncher()));

  tearDown(() => getIt.reset());

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

      expect(launcher.launchedUris.map((uri) => uri.toString()), [
        'tel:01014194042',
      ]);
    });

    testWidgets('does not touch the WhatsApp link', (tester) async {
      await _pumpCard(tester);

      await tester.tap(_callButton());
      await tester.pump();

      expect(
        launcher.launchedUris.any((uri) => uri.toString().contains('wa.me')),
        isFalse,
      );
    });
  });

  group('CustomContractCard - WhatsApp button', () {
    testWidgets('opens the wa.me chat link for the phone number', (
      tester,
    ) async {
      await _pumpCard(tester, phone: '01014194042');

      await tester.tap(_whatsAppButton());
      await tester.pump();

      expect(launcher.launchedUris.single.toString(), 'https://wa.me/01014194042');
    });

    testWidgets('strips spaces, dashes and the plus sign from the number', (
      tester,
    ) async {
      await _pumpCard(tester, phone: '+20 101-419-4042');

      await tester.tap(_whatsAppButton());
      await tester.pump();

      expect(launcher.launchedUris.single.toString(), 'https://wa.me/201014194042');
    });

    testWidgets('opens in the external WhatsApp app, not in a web view', (
      tester,
    ) async {
      await _pumpCard(tester);

      await tester.tap(_whatsAppButton());
      await tester.pump();

      expect(launcher.modes.single, LaunchMode.externalApplication);
    });
  });

  group('CustomContractCard - when the link cannot be opened', () {
    setUp(() => registerLauncher(_FakeUrlLauncher(canLaunchResult: false)));

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

        expect(launcher.launchedUris, isEmpty);
        expect(find.text(AppLocalizationsEn().somethingWentWrong), findsOneWidget);
        expect(
          tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
          AppColors.error,
        );
      });
    }
  });
}
