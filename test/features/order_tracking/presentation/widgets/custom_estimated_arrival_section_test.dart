import 'package:flower_app/features/order_tracking/presentation/widgets/custom_estimated_arrival_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/order_tracking_test_helpers.dart';
import 'package:flower_app/l10n/app_localizations_en.dart';

Widget _section(DateTime dateTime) =>
    CustomEstimatedArrivalSection(estimatedArrivalDateTime: dateTime);

void main() {
  group('CustomEstimatedArrivalSection', () {
    testWidgets('shows the "Estimated arrival" label', (tester) async {
      await pumpOrderTrackingApp(tester, _section(DateTime(2024, 9, 3, 11)));

      expect(find.text(AppLocalizationsEn().estimatedArrival), findsOneWidget);
    });

    testWidgets('formats a morning time as "3 September 2024, 11:00 AM"', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _section(DateTime(2024, 9, 3, 11)));

      expect(find.text('3 September 2024, 11:00 AM'), findsOneWidget);
    });

    testWidgets('formats an afternoon time with PM and a 12-hour clock', (
      tester,
    ) async {
      await pumpOrderTrackingApp(
        tester,
        _section(DateTime(2024, 12, 25, 15, 45)),
      );

      expect(find.text('25 December 2024, 3:45 PM'), findsOneWidget);
    });

    testWidgets('shows midnight as 12:00 AM and noon as 12:00 PM', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _section(DateTime(2024, 9, 3, 0, 0)));
      expect(find.text('3 September 2024, 12:00 AM'), findsOneWidget);

      await pumpOrderTrackingApp(tester, _section(DateTime(2024, 9, 3, 12, 0)));
      expect(find.text('3 September 2024, 12:00 PM'), findsOneWidget);
    });

    testWidgets('does not pad the day or the hour with a leading zero', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _section(DateTime(2025, 1, 2, 9, 5)));

      expect(find.text('2 January 2025, 9:05 AM'), findsOneWidget);
    });

    testWidgets('draws a divider under the section', (tester) async {
      await pumpOrderTrackingApp(tester, _section(DateTime(2024, 9, 3, 11)));

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('updates the text when a new date is passed in', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _section(DateTime(2024, 9, 3, 11)));
      expect(find.text('3 September 2024, 11:00 AM'), findsOneWidget);

      await pumpOrderTrackingApp(tester, _section(DateTime(2025, 1, 2, 9, 5)));

      expect(find.text('2 January 2025, 9:05 AM'), findsOneWidget);
      expect(find.text('3 September 2024, 11:00 AM'), findsNothing);
    });
  });
}
