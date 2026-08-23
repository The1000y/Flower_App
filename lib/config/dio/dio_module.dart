import 'package:dio/dio.dart';
import 'package:flower_app/config/dio/auth_interceptor.dart';
import 'package:flower_app/config/utils/app_config.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio(SecureStorageService secureStorage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.add(AuthInterceptors(secureStorage));
    return dio;
  }
}
