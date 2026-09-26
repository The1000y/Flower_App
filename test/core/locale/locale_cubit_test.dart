import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const localeKey = 'app_locale';
  const arabic = Locale('ar');
  const english = Locale('en');

  Future<SharedPreferences> initPrefs([
    Map<String, Object> stored = const <String, Object>{},
  ]) async {
    SharedPreferences.setMockInitialValues(stored);
    return SharedPreferences.getInstance();
  }

  group('LocaleCubit', () {
    test('defaults to English before load() is called', () async {
      final cubit = LocaleCubit(await initPrefs());
      addTearDown(cubit.close);

      expect(cubit.state, english);
    });

    group('load()', () {
      blocTest<LocaleCubit, Locale>(
        'emits Arabic when "ar" is persisted',
        build: () =>
            LocaleCubit(_InMemoryPrefs({localeKey: arabic.languageCode})),
        act: (cubit) => cubit.load(),
        expect: () => <Locale>[arabic],
      );

      test(
        'emits the stored Arabic locale through a real SharedPreferences',
        () async {
          final cubit = LocaleCubit(await initPrefs({localeKey: 'ar'}));
          addTearDown(cubit.close);

          await cubit.load();

          expect(cubit.state, arabic);
        },
      );

      blocTest<LocaleCubit, Locale>(
        'emits English when "en" is persisted',
        build: () =>
            LocaleCubit(_InMemoryPrefs({localeKey: english.languageCode})),
        act: (cubit) => cubit.load(),
        expect: () => <Locale>[english],
      );

      blocTest<LocaleCubit, Locale>(
        'emits English when nothing is persisted',
        build: () => LocaleCubit(_InMemoryPrefs(const <String, Object>{})),
        act: (cubit) => cubit.load(),
        expect: () => <Locale>[english],
      );

      blocTest<LocaleCubit, Locale>(
        'emits English for an unsupported persisted language code',
        build: () => LocaleCubit(_InMemoryPrefs({localeKey: 'fr'})),
        act: (cubit) => cubit.load(),
        expect: () => <Locale>[english],
      );

      test('falls back to English when the storage read throws', () async {
        final cubit = LocaleCubit(_ThrowingPrefs());
        addTearDown(cubit.close);

        await cubit.load();

        expect(cubit.state, english);
      });

      test('round-trips a persisted locale', () async {
        final prefs = await initPrefs();
        final cubit = LocaleCubit(prefs);
        addTearDown(cubit.close);

        await cubit.changeLocale(arabic);
        await cubit.load();

        expect(cubit.state, arabic);
      });
    });

    group('changeLocale()', () {
      blocTest<LocaleCubit, Locale>(
        'emits and persists the new locale',
        build: () => LocaleCubit(_InMemoryPrefs(<String, Object>{})),
        act: (cubit) => cubit.changeLocale(arabic),
        expect: () => <Locale>[arabic],
      );

      blocTest<LocaleCubit, Locale>(
        'does not emit when the locale is unchanged',
        build: () => LocaleCubit(_InMemoryPrefs(<String, Object>{})),
        act: (cubit) => cubit.changeLocale(english),
        expect: () => <Locale>[],
      );

      test('writes the language code to storage', () async {
        final prefs = await initPrefs();
        final cubit = LocaleCubit(prefs);
        addTearDown(cubit.close);

        await cubit.changeLocale(arabic);

        expect(prefs.getString(localeKey), arabic.languageCode);
      });

      test('still emits the new locale when persistence fails', () async {
        final cubit = LocaleCubit(_ThrowingPrefs());
        addTearDown(cubit.close);

        await cubit.changeLocale(arabic);

        expect(cubit.state, arabic);
      });
    });

    group('currentLanguageName', () {
      test('returns the Arabic name for the ar locale', () async {
        final cubit = LocaleCubit(await initPrefs());
        addTearDown(cubit.close);

        await cubit.changeLocale(arabic);

        expect(cubit.currentLanguageName, 'العربية');
      });

      test('returns the English name for the en locale', () async {
        final cubit = LocaleCubit(await initPrefs());
        addTearDown(cubit.close);

        expect(cubit.currentLanguageName, 'English');
      });
    });
  });
}

/// Minimal in-memory [SharedPreferences] so the tests do not depend on the
/// platform-channel store.
class _InMemoryPrefs implements SharedPreferences {
  _InMemoryPrefs(this._values);

  final Map<String, Object> _values;

  @override
  String? getString(String key) => _values[key] as String?;

  @override
  Future<bool> setString(String key, String value) async {
    _values[key] = value;
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} is not used by LocaleCubit',
  );
}

/// Fails every access so the cubit's error handling can be exercised.
class _ThrowingPrefs implements SharedPreferences {
  @override
  String? getString(String key) => throw Exception('storage unavailable');

  @override
  Future<bool> setString(String key, String value) =>
      Future<bool>.error(Exception('storage unavailable'));

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} is not used by LocaleCubit',
  );
}
