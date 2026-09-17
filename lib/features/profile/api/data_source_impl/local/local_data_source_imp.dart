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
    try {
      final response = await _secureStorage.getUser();

      if (response == null || response.isEmpty) {
        return ErrorResponce<UserDto>(
          Exception(AppStrings.usernotfound),
        );
      }

      final Map<String, dynamic> jsonData = jsonDecode(response);
      final user = UserDto.fromJson(jsonData);

      return SuccessResponce<UserDto>(user);
    } catch (error) {
      return ErrorResponce<UserDto>(
        error is Exception ? error : Exception(error.toString()),
      );
    }
  }
}
