import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/body_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../helpers/app_localizations_test_helper.dart';

const testUser = UserEntity(
  id: 1,
  fullName: 'Nour Mohamed',
  email: 'nour@example.com',
  phoneNumber: '+201234567890',
  gender: 'female',
  role: 'user',
  status: 'active',
);

void main() {
  late LocaleCubit localeCubit;
  late int editTaps;
  late int notificationTaps;
  late int logoutTaps;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    localeCubit = LocaleCubit(await SharedPreferences.getInstance());
    editTaps = 0;
    notificationTaps = 0;
    logoutTaps = 0;
  });

  tearDown(() => localeCubit.close());

  Widget wrap(Widget child) {
    return MaterialApp(
      localizationsDelegates: AppLocalizationsOfTest.delegates,
      supportedLocales: AppLocalizationsOfTest.locales,
      locale: const Locale('en'),
      home: BlocProvider<LocaleCubit>.value(
        value: localeCubit,
        child: Scaffold(body: child),
      ),
    );
  }

  ProfileBody buildBody({UserEntity? user = testUser}) {
    return ProfileBody(
      user: user,
      onEditProfile: () => editTaps++,
      onNotification: () => notificationTaps++,
      onLanguage: () {},
      onLogout: () => logoutTaps++,
    );
  }

  group('ProfileBody profile info', () {
    testWidgets('renders the name and email from the user', (tester) async {
      await tester.pumpWidget(wrap(buildBody()));

      expect(find.text('Nour Mohamed'), findsOneWidget);
      expect(find.text('nour@example.com'), findsOneWidget);
    });

    testWidgets('renders empty strings when the user is null', (tester) async {
      await tester.pumpWidget(wrap(buildBody(user: null)));

      // No hardcoded placeholder data may leak into the UI.
      expect(find.text('Nour'), findsNothing);
      expect(find.text('Nour_Mohamed@gmail.com'), findsNothing);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('renders empty strings for a user with blank fields', (
      tester,
    ) async {
      const blankUser = UserEntity(
        id: 0,
        fullName: '',
        email: '',
        phoneNumber: '',
        gender: '',
        role: '',
        status: '',
      );

      await tester.pumpWidget(wrap(buildBody(user: blankUser)));

      expect(find.text('Nour'), findsNothing);
      expect(find.text('Nour_Mohamed@gmail.com'), findsNothing);
    });

    testWidgets('shows the avatar fallback icon without a photo', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(buildBody()));

      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });

  group('ProfileBody header actions', () {
    testWidgets('invokes onEditProfile when the edit icon is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(buildBody()));

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pump();

      expect(editTaps, 1);
    });

    testWidgets('invokes onNotification when the bell icon is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(buildBody()));

      await tester.tap(find.byIcon(Icons.notifications_none_outlined));
      await tester.pump();

      expect(notificationTaps, 1);
    });
  });

  group('ProfileBody notification switch', () {
    Switch switchWidget(WidgetTester tester) =>
        tester.widget<Switch>(find.byType(Switch));

    testWidgets('is enabled by default', (tester) async {
      await tester.pumpWidget(wrap(buildBody()));

      expect(switchWidget(tester).value, isTrue);
    });

    testWidgets('toggling the Switch updates its value', (tester) async {
      await tester.pumpWidget(wrap(buildBody()));
      expect(switchWidget(tester).value, isTrue);

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(switchWidget(tester).value, isFalse);
    });

    testWidgets('toggling the Switch twice restores the original value', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(buildBody()));

      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(switchWidget(tester).value, isFalse);

      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(switchWidget(tester).value, isTrue);
    });

    testWidgets('tapping the notification row also flips the Switch', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(buildBody()));
      expect(switchWidget(tester).value, isTrue);

      await tester.tap(find.text('Notification'));
      await tester.pump();

      expect(switchWidget(tester).value, isFalse);
    });
  });

  group('ProfileBody options', () {
    testWidgets('renders the localized option titles', (tester) async {
      await tester.pumpWidget(wrap(buildBody()));

      expect(find.text('My orders'), findsOneWidget);
      expect(find.text('Saved address'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Notification'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('shows the current language name from LocaleCubit', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(buildBody()));
      expect(find.text('English'), findsOneWidget);

      await localeCubit.changeLocale(const Locale('ar'));
      await tester.pump();

      expect(find.text('العربية'), findsOneWidget);
    });
  });
}
