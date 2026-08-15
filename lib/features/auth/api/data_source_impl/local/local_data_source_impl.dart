import 'dart:developer';

import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/api/data_source_impl/local/dummy.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/request_login.dart';
import 'package:flower_app/features/auth/data/model/responce/login_responce/response_login.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  @override
  Future<ResponseLogin> login(RequestLogin login) async {
    // TODO: implement login
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (login.email == Dummy.email && login.password == Dummy.pass) {
        return ResponseLogin.fromJson(Dummy.dummyLoginResponse);
      }
      return ResponseLogin(
        isSuccess: false,
        errorCode: 401,
        message: AppStrings.invalidCredentials,
        data: null,
      );
    } catch (e) {
      log(e.toString());

      return ResponseLogin(
        isSuccess: false,
        errorCode: 500,
        message: AppStrings.somethingWentWrong,
        data: null,
      );
    }
  }
}
