import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base/base_responce.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repo/profile_repo.dart';

import '../model/request/update_profile_request_dto.dart';
import '../model/response/get_profile_response_dto.dart';

// TODO: Dummy fallback for Profile data. Remove or replace when live API/auth flow is active.
const _dummyUserEntity = UserEntity(
  id: 1,
  fullName: "John Doe",
  email: "john.doe@example.com",
  phoneNumber: "+1234567890",
  gender: "male",
  role: "user",
  status: "active",
);

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource profData;

  ProfileRepoImpl(this._remoteDataSource, this.profData);

  @override
  Future<BaseResponce<UserEntity>> getProfile() async {
    final userData = await profData.getProfile();

    switch (userData) {
      case SuccessResponce():
        return SuccessResponce(userData.data.toUserEntity());
      case ErrorResponce():
        // Fallback to dummy profile data if local storage fails or is empty.
        // To remove this fallback, simply return: return ErrorResponce(userData.error);
        return SuccessResponce(_dummyUserEntity);
    }
  }

  @override
  Future<BaseResponce<ProfileEntity>> updateProfile(ProfileEntity profile) async {
    final request = UpdateProfileRequestDto.fromDomain(profile);
    final response = await _remoteDataSource.updateProfile(request);

    return switch (response) {
      SuccessResponce<GetProfileResponseDto>() => SuccessResponce(response.data.toDomain()),
      ErrorResponce<GetProfileResponseDto>() => ErrorResponce(response.error),
    };
  }

  @override
  Future<BaseResponce<ChangePasswordEntity>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final request = ChangePasswordRequest(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmPassword,
    );

    final response = await _remoteDataSource.changePassword(request);

    switch (response) {
      case SuccessResponce<ChangePasswordResponse>():
        return SuccessResponce<ChangePasswordEntity>(response.data.toEntity());
      case ErrorResponce<ChangePasswordResponse>():
        return ErrorResponce<ChangePasswordEntity>(response.error);
    }
  }
}
