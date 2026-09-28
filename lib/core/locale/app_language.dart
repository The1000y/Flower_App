import 'package:flutter/widgets.dart';

/// The set of languages the app can be displayed in.
///
/// Modelled as an enum rather than a raw [Locale] so the supported languages are
/// a closed set: language codes, native display names and the "is this Arabic?"
/// question are all answered here instead of being hard-coded as string
/// comparisons at each call site.
enum AppLanguage {
  english(languageCode: 'en', nativeName: 'English'),
  arabic(languageCode: 'ar', nativeName: 'العربية');

  const AppLanguage({required this.languageCode, required this.nativeName});

  /// ISO-639-1 code persisted in storage and handed to [MaterialApp.locale].
  final String languageCode;

  /// Name shown in the language picker, always in the language itself.
  final String nativeName;

  /// The [Locale] to hand to Flutter's localisation delegates.
  Locale get locale => Locale(languageCode);

  /// Whether this is the right-to-left language.
  bool get isArabic => this == AppLanguage.arabic;

  /// Language used when nothing valid is persisted.
  static const AppLanguage fallback = AppLanguage.english;

  /// Resolves a persisted [code] back to a language, falling back to [fallback]
  /// for `null`, unknown and malformed values so the app can never end up in a
  /// locale the delegates do not support.
  static AppLanguage fromLanguageCode(String? code) {
    for (final language in AppLanguage.values) {
      if (language.languageCode == code) return language;
    }
    return fallback;
  }
}
