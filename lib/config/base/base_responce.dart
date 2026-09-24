import 'package:flower_app/config/errors/hadel_error_exception.dart';

sealed class BaseResponce<T> {}
class SuccessResponce<T> extends BaseResponce<T> {
  final T data;
  SuccessResponce(this.data);
}
class ErrorResponce<T> extends BaseResponce<T> {
  final String errorMessage;
  final Exception error;
  ErrorResponce(this.error) : errorMessage = HandelErrorException().handelErrorexception(error);
}


//another way to initialize th final string messsage that write late to not create constractor until initialize the message 
// but this way less safety

// class EroreResponce<T> extends BaseResponce<T> {
//   late final String errorMessage;
//   final Exception error;
//   EroreResponce(this.error ){
//     errorMessage = HandelErrorException().handelErrorexception(error);
//   } 
// }




// error responce hold only string message and we handle it in catch 
/*
static String handle(Object error) {
  if (error is DioException) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final model = ErrorResponseModel.fromJson(data);

      if (model.message != null && model.message!.isNotEmpty) {
        return model.message!;
      }
    }

    // مفيش رسالة من الباك
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';

      case DioExceptionType.connectionError:
        return 'No internet connection';

      case DioExceptionType.badResponse:
        return 'Server error';

      default:
        return 'Something went wrong';
    }
  }

  return 'Something went wrong';
}
*/


