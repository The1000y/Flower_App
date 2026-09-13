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
        return ErrorResponce(userData.error);
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

    // 2. إرسال الـ Request للـ DataSource
    final response = await _remoteDataSource.changePassword(request);

    // 3. التحويل وإرجاع النتيجة
    switch (response) {
      case SuccessResponce<ChangePasswordResponse>():
        return SuccessResponce<ChangePasswordEntity>(response.data.toEntity());
      case ErrorResponce<ChangePasswordResponse>():
        return ErrorResponce<ChangePasswordEntity>(response.error);
    }
  }
}