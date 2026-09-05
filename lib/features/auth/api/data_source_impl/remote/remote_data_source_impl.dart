import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/login_request.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/data/model/response/login_response/login_response.dart';
import 'package:flower_app/features/auth/data/model/responce/register_responce/register_response.dart';
import 'package:injectable/injectable.dart';

import '../../client/auth_api_client.dart';

@Injectable(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final AuthApi _authApi;
  RemoteDataSourceImpl(this._authApi);

  @override
  Future<LoginResponse> login(LoginRequest login) async {
    try {
      return await _authApi.login(login);
    } on DioException catch (e) {
      log(e.toString());
      return LoginResponse(
        isSuccess: false,
        errorCode: e.response?.statusCode ?? 500,
        message: AppStrings.somethingWentWrong,
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
    try {
      return await _authApi.register(request);
    } on DioException catch (e) {
      log(e.toString());
      return RegisterResponse(
        isSuccess: false,
        errorCode: e.response?.statusCode ?? 500,
        message: AppStrings.somethingWentWrong,
        data: false,
      );
    } catch (e) {
      log(e.toString());
      return RegisterResponse(
        isSuccess: false,
        errorCode: 500,
        message: AppStrings.somethingWentWrong,
        data: false,
      );
    }
  }
}