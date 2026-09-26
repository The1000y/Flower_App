import 'package:flower_app/features/profile/presentation/view/widgets/option_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileOptionTile renders title and responds to tap', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileOptionTile(
            icon: Icons.person,
            title: 'My Profile',
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    await tester.tap(find.byType(ProfileOptionTile));
    expect(tapped, isTrue);
  });

  testWidgets('ProfileOptionTile displays trailing text when provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileOptionTile(
            icon: Icons.language,
            title: 'Language',
            trailingText: 'English',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });

  testWidgets(
    'ProfileOptionTile displays custom leading and trailing widgets',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileOptionTile(
              leading: const Icon(Icons.circle, key: Key('custom_leading')),
              title: 'Custom Tile',
              trailing: const Icon(Icons.star, key: Key('custom_trailing')),
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('custom_leading')), findsOneWidget);
      expect(find.text('Custom Tile'), findsOneWidget);
      expect(find.byKey(const Key('custom_trailing')), findsOneWidget);
    },
  );
}
