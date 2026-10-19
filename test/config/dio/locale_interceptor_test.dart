import 'package:dio/dio.dart';
import 'package:flower_app/config/dio/locale_interceptor.dart';
import 'package:flower_app/core/locale/app_language.dart';
import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocaleCubit localeCubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    localeCubit = LocaleCubit(await SharedPreferences.getInstance());
  });

  tearDown(() => localeCubit.close());

  test('adds the current locale as the Accept-Language header', () async {
    await localeCubit.changeLanguage(AppLanguage.arabic);

    final interceptor = LocaleInterceptors(localeCubit);
    final options = RequestOptions();
    interceptor.onRequest(options, RequestInterceptorHandler());

    expect(options.headers['Accept-Language'], AppLanguage.arabic.languageCode);
  });

  test('uses the fallback locale before a language has been selected', () {
    final interceptor = LocaleInterceptors(localeCubit);
    final options = RequestOptions();
    interceptor.onRequest(options, RequestInterceptorHandler());

    expect(
      options.headers['Accept-Language'],
      AppLanguage.fallback.languageCode,
    );
  });
}
