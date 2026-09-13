import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  static const String _localeKey = 'app_locale';
  static const String _arabicName = 'العربية';
  static const String _englishName = 'English';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);
    emit(code == 'ar' ? const Locale('ar') : const Locale('en'));
  }

  Future<void> changeLocale(Locale locale) async {
    if (locale == state) return;
    emit(locale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  String get currentLanguageName =>
      state.languageCode == 'ar' ? _arabicName : _englishName;
}