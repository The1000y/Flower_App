
import 'package:flower_app/features/auth/data/model/request/login_request/request_login.dart';
import 'package:flower_app/features/auth/data/model/responce/login_responce/response_login.dart';

import '../../model/request/register_request/register_request.dart';
import '../../model/responce/register_responce/register_response.dart';

abstract class AuthLocalDataSource {
 Future<ResponseLogin> login(RequestLogin login);
Future<RegisterResponse> register(RegisterRequest request);
}
