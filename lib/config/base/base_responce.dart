
import 'package:flower_app/config/errors/hadel_error_exception.dart';

sealed class BaseResponce<T> {}


class SuccessResponce<T> extends BaseResponce<T> {
  final T data;
  SuccessResponce(this.data);
}

class ErrorResponce<T> extends BaseResponce<T> {
  final String errorMessage;
  final Exception error;
  ErrorResponce(this.error ) : errorMessage = HandelErrorException().handelErrorexception(error);
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



