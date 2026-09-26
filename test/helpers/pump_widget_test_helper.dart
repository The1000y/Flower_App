import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Wraps [child] in the minimum app scaffolding needed to pump widgets that
/// depend on `AppLocalizations` (which cannot be resolved without a
/// `MaterialApp` plus the generated delegates).
Widget wrapLocalized(
  Widget child, {
  Locale locale = const Locale('en'),
  NavigatorObserver? navigatorObserver,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    navigatorObservers: [?navigatorObserver],
    home: Scaffold(body: child),
  );
}
