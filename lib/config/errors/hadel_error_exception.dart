import 'package:dio/dio.dart';

class HandelErrorException {
  String handelErrorexception(Exception error) {
    if(error is DioException) return _hadelDioException(error);
    return 'something went wrong, pls try again';
  }

 String _hadelDioException(DioException error) {
   switch (error.type) {
     case DioExceptionType.badCertificate:
       return 'badCertificate';
     case DioExceptionType.badResponse:
       return 'badResponse';
     case DioExceptionType.cancel:
       return 'cancel';
     case DioExceptionType.connectionTimeout:
       return 'connectionTimeout';
     case DioExceptionType.connectionError:
       return 'connectionError';
     case DioExceptionType.unknown:
       return 'unknown';
     case DioExceptionType.receiveTimeout:
       return 'receiveTimeout';
     case DioExceptionType.sendTimeout:
       return 'sendTimeout';
     case DioExceptionType.transformTimeout:
       return 'transformTimeout'; 
   }

 }



}
