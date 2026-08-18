

import '../../model/request/register_request/register_request.dart';
import '../../model/responce/register_responce/register_response.dart';

abstract class AuthLocalDataSource {
Future<RegisterResponse> register(RegisterRequest request);
}
