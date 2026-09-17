import 'package:flower_app/core/shared/app_widgets/custom_snack_bar.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomSnackBar', () {
    testWidgets('showSuccess shows SnackBar with green background and message',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CustomSnackBar.showSuccess(
                  context,
                  message: 'Address added successfully',
                ),
                child: const Text('Show Success'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Success'));
      await tester.pump();

      expect(find.text('Address added successfully'), findsOneWidget);
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, AppColors.success);
    });

    testWidgets('showError shows SnackBar with error background and message',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CustomSnackBar.showError(
                  context,
                  message: 'Failed to add address',
                ),
                child: const Text('Show Error'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Error'));
      await tester.pump();

      expect(find.text('Failed to add address'), findsOneWidget);
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, AppColors.error);
    });

    test('success factory method creates SnackBar with correct properties', () {
      final snackBar = CustomSnackBar.success(message: 'Success Message');
      expect(snackBar.backgroundColor, AppColors.success);
      expect((snackBar.content as Text).data, 'Success Message');
    });

    test('error factory method creates SnackBar with correct properties', () {
      final snackBar = CustomSnackBar.error(message: 'Error Message');
      expect(snackBar.backgroundColor, AppColors.error);
      expect((snackBar.content as Text).data, 'Error Message');
    });
  });
}
