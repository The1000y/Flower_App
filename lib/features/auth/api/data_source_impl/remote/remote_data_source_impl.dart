import 'dart:developer';

import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/data/model/responce/register_responce/register_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  const RemoteDataSourceImpl();

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    // TODO: implement register
    try {
      await Future.delayed(const Duration(seconds: 2));
      return RegisterResponse(
        isSuccess: true,
        errorCode: 200,
        message: "Registration successful",
        data: true,
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