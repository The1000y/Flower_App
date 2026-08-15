import 'package:flower_app/features/auth/data/model/request/login_request/request_login.dart';
import 'package:flower_app/features/auth/data/model/responce/login_responce/response_login.dart';

abstract class LocalDataSource {

  Future<ResponseLogin> login(RequestLogin login);
}
