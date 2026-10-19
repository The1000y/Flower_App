import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flower_app/l10n/app_localizations_en.dart';
import 'package:flutter/widgets.dart';

/// Convenience access to the current [AppLocalizations] from a [BuildContext].
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this) ?? L10n.instance;
}

/// Provides the active [AppLocalizations] to code that has no [BuildContext]
/// (validators, repositories, cubits...).
///
/// [L10n.instance] falls back to English until [update] is called from the app
/// root, which keeps the app working before the first frame and in tests.
class L10n {
  L10n._();

  static AppLocalizations _instance = AppLocalizationsEn();

  static AppLocalizations get instance => _instance;

  static void update(AppLocalizations localizations) => _instance = localizations;
}
