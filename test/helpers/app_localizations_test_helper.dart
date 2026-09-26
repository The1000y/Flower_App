import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// Localizations scaffolding shared by widget tests.
abstract class AppLocalizationsOfTest {
  static List<Locale> get locales => AppLocalizations.supportedLocales;

  static List<LocalizationsDelegate<dynamic>> get delegates =>
      AppLocalizations.localizationsDelegates;
}
