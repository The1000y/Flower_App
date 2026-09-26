

import 'package:dio/dio.dart';
import 'package:flower_app/config/dio/auth_interceptor.dart';
import 'package:flower_app/core/constants/api_strings/api_strings.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiStrings.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Accept-Language': 'en',
          'Content-Type': 'application/json',
        },
      ),
    );
    dio.interceptors.add(AuthInterceptors());
    return dio;
  }
}





