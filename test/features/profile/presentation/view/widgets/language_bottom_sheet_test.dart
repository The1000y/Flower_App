import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/language.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocaleCubit localeCubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    localeCubit = LocaleCubit(await SharedPreferences.getInstance());
  });

  tearDown(() => localeCubit.close());

  Widget wrap({Locale locale = const Locale('en')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<LocaleCubit>.value(
        value: localeCubit,
        child: const Scaffold(body: LanguageBottomSheet()),
      ),
    );
  }

  testWidgets('displays title and options in English', (tester) async {
    await tester.pumpWidget(wrap());

    expect(find.text('Change Language'), findsOneWidget);
    expect(find.text('Arabic'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
  });

  testWidgets('marks English as selected for the en locale', (tester) async {
    await tester.pumpWidget(wrap());

    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    expect(find.byIcon(Icons.radio_button_off), findsOneWidget);
  });

  testWidgets('marks Arabic as selected for the ar locale', (tester) async {
    await localeCubit.changeLocale(const Locale('ar'));

    await tester.pumpWidget(wrap());

    expect(find.byIcon(Icons.radio_button_off), findsOneWidget);
    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
  });

  testWidgets('switches to Arabic and persists the locale', (tester) async {
    await tester.pumpWidget(wrap());

    await tester.tap(find.text('Arabic'));
    await tester.pump();

    expect(localeCubit.state.languageCode, 'ar');
  });

  testWidgets('switches back to English', (tester) async {
    await localeCubit.changeLocale(const Locale('ar'));
    await tester.pumpWidget(wrap());

    await tester.tap(find.text('English'));
    await tester.pump();

    expect(localeCubit.state.languageCode, 'en');
  });

  testWidgets('renders Arabic labels when the app locale is Arabic', (
    tester,
  ) async {
    await localeCubit.changeLocale(const Locale('ar'));

    await tester.pumpWidget(wrap(locale: const Locale('ar')));

    expect(find.text('تغيير اللغة'), findsOneWidget);
  });
}
