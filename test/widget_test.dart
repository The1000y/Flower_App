import 'package:flower_app/config/di/di.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flower_app/main.dart';

void main() {
  setUpAll(() {
    configureDependencies();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlowerApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsNothing);
  });
}
