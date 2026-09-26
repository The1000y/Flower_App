import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Owns the app language and persists the selected locale.
///
/// [SharedPreferences] is injected so the storage layer can be replaced in
/// tests; the cubit is registered in the DI container as a lazy singleton.
@lazySingleton
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._prefs) : super(fallbackLocale);

  final SharedPreferences _prefs;

  /// Locale used when nothing (valid) is stored yet.
  static const Locale fallbackLocale = Locale('en');

  static const String _localeKey = 'app_locale';
  static const String _arabicCode = 'ar';
  static const String _arabicName = 'العربية';
  static const String _englishName = 'English';

  /// Restores the persisted locale, falling back to [fallbackLocale] when the
  /// stored value is missing or the storage read fails. Never throws.
  Future<void> load() async {
    try {
      final code = _prefs.getString(_localeKey);
      emit(code == _arabicCode ? const Locale(_arabicCode) : fallbackLocale);
    } catch (e) {
      debugPrint('Failed to load locale, falling back to default: $e');
      emit(fallbackLocale);
    }
  }

  /// Emits [locale] and persists it. Never throws, so a storage failure cannot
  /// leave the cubit in an inconsistent state.
  Future<void> changeLocale(Locale locale) async {
    if (locale == state) return;

    emit(locale);
    try {
      await _prefs.setString(_localeKey, locale.languageCode);
    } catch (e) {
      debugPrint('Failed to persist locale: $e');
    }
  }

  String get currentLanguageName =>
      state.languageCode == _arabicCode ? _arabicName : _englishName;
}
