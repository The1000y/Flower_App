import 'package:dio/dio.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/locale/app_language.dart';
import 'package:flower_app/core/locale/locale_cubit.dart';

class LocaleInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = _languageCode();
    handler.next(options);
  }

  String _languageCode() {
    try {
      return getIt<LocaleCubit>().state.languageCode;
    } catch (_) {
      return AppLanguage.fallback.languageCode;
    }
  }
}
