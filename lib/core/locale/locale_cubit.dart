import 'package:flower_app/core/locale/app_language.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class LocaleCubit extends Cubit<AppLanguage> {
  LocaleCubit(this._prefs) : super(AppLanguage.fallback);

  final SharedPreferences _prefs;

  static const String _localeKey = 'app_locale';


  Future<void> load() async {
    try {
      emit(AppLanguage.fromLanguageCode(_prefs.getString(_localeKey)));
    } catch (e) {
      debugPrint('Failed to load locale, falling back to default: $e');
      emit(AppLanguage.fallback);
    }
  }

 
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
