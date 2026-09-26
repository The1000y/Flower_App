import 'dart:convert';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/data/model/user_dto.dart';
import 'package:flower_app/features/profile/data/data_source/local_data_source/local_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImp implements ProfileLocalDataSource {
  final SecureStorageService _secureStorage;

  ProfileLocalDataSourceImp(this._secureStorage);

  @override
  Future<BaseResponce<UserDto>> getProfile() async {
    final String? response;
    try {
      response = await _secureStorage.getUser();
    } catch (error) {
      return _error(error);
    }

    if (response == null || response.isEmpty) {
      return ErrorResponce<UserDto>(Exception(AppStrings.usernotfound));
    }

    // Corrupted secure-storage contents must not crash the app.
    final Map<String, dynamic> jsonData;
    try {
      final decoded = jsonDecode(response);
      if (decoded is! Map<String, dynamic>) {
        return ErrorResponce<UserDto>(Exception(AppStrings.usernotfound));
      }
      jsonData = decoded;
    } on FormatException catch (error) {
      return _error(error);
    }

    try {
      return SuccessResponce<UserDto>(UserDto.fromJson(jsonData));
    } catch (error) {
      return _error(error);
    }
  }

  ErrorResponce<UserDto> _error(Object error) {
    return ErrorResponce<UserDto>(
      error is Exception ? error : Exception(error.toString()),
    );
  }
}
