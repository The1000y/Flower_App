import 'dart:developer';

import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/api/data_source_impl/remote/dummy.dart';
import 'package:flower_app/features/auth/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/login_request.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/data/model/response/login_response/login_response.dart';
import 'package:flower_app/features/auth/data/model/responce/register_responce/register_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  @override
  Future<LoginResponse> login(LoginRequest login) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (login.email == Dummy.email && login.password == Dummy.pass) {
        return LoginResponse.fromJson(Dummy.dummyLoginResponse);
      }
      return LoginResponse(
        isSuccess: false,
        errorCode: 401,
        message: AppStrings.invalidCredentials,
        data: null,
      );
    } catch (e) {
      log(e.toString());

      return LoginResponse(
        isSuccess: false,
        errorCode: 500,
        message: AppStrings.somethingWentWrong,
        data: null,
      );
    }
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    return RegisterResponse(
      isSuccess: true,
      errorCode: 200,
      message: 'Registration successful',
      data: true,
    );
  }
}