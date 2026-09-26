import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/language.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LanguageBottomSheet displays title and options in English', (tester) async {
    final localeCubit = LocaleCubit();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<LocaleCubit>.value(
          value: localeCubit,
          child: const Scaffold(
            body: LanguageBottomSheet(),
          ),
        ),
      ),
    );

    expect(find.text('Change Language'), findsOneWidget);
    expect(find.text('Arabic'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
  });

  testWidgets('LanguageBottomSheet allows switching to Arabic', (tester) async {
    final localeCubit = LocaleCubit();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<LocaleCubit>.value(
          value: localeCubit,
          child: const Scaffold(
            body: LanguageBottomSheet(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Arabic'));
    await tester.pump();

    expect(localeCubit.state.languageCode, 'ar');
  });
}
