import 'package:dio/dio.dart';

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');

    //add method that get token from secure storage
    
    super.onRequest(options, handler);
  }
  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    //add method that delete token from secure storage
    super.onError(err, handler);
  }
}


