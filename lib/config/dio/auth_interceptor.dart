import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');

    //add method that get token from secure storage
    
    super.onRequest(options, handler);
  }
  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    //add method that delete token from secure storage
    super.onError(err, handler);
  }
}


