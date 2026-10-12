import 'package:dio/dio.dart';
import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:injectable/injectable.dart';

@injectable
class LocaleInterceptors extends Interceptor {
  LocaleInterceptors(this._localeCubit);

  final LocaleCubit _localeCubit;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = _localeCubit.state.languageCode;
    handler.next(options);
  }
}
