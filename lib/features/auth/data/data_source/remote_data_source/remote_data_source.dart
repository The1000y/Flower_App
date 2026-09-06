import 'package:flower_app/features/auth/data/model/request/login_request/login_request.dart';
import 'package:flower_app/features/auth/data/model/response/login_response/login_response.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/data/model/responce/register_responce/register_response.dart';

abstract interface class RemoteDataSource {
  Future<LoginResponse> login(LoginRequest login);
  Future<RegisterResponse> register(RegisterRequest request);
}