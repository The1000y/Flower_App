import 'package:flower_app/core/locale/app_language.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Owns the app language and persists the selected one.
///
/// The state is an [AppLanguage] rather than a raw [Locale], so "the app is in
/// Arabic" is a property of the state instead of a string comparison against
/// `'ar'` scattered through the widget tree.
///
/// [SharedPreferences] is injected so the storage layer can be replaced in
/// tests; the cubit is registered in the DI container as a lazy singleton.
@lazySingleton
class LocaleCubit extends Cubit<AppLanguage> {
  LocaleCubit(this._prefs) : super(AppLanguage.fallback);

  final SharedPreferences _prefs;

  static const String _localeKey = 'app_locale';

  /// Restores the persisted language, falling back to [AppLanguage.fallback]
  /// when the stored value is missing, unknown or the storage read fails.
  /// Never throws.
  Future<void> load() async {
    try {
      emit(AppLanguage.fromLanguageCode(_prefs.getString(_localeKey)));
    } catch (e) {
      debugPrint('Failed to load locale, falling back to default: $e');
      emit(AppLanguage.fallback);
    }
  }

  /// Emits [language] and persists it. Never throws, so a storage failure cannot
  /// leave the cubit in an inconsistent state.
  Future<void> changeLanguage(AppLanguage language) async {
    if (language == state) return;

    emit(language);
    try {
      await _prefs.setString(_localeKey, language.languageCode);
    } catch (e) {
      debugPrint('Failed to persist locale: $e');
    }
  }
}
