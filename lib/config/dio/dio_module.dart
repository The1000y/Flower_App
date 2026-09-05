import 'package:dio/dio.dart';
import 'package:flower_app/config/dio/auth_interceptor.dart';
import 'package:flower_app/core/constants/api_strings/api_constants.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/api/client/auth_api_client.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ),
    );
    dio.interceptors.add(AuthInterceptors());
    return dio;
  }

  @lazySingleton
  AuthApi authApi(Dio dio) => AuthApi(dio);
}