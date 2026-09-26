import 'package:injectable/injectable.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import '../../../../config/base/base_responce.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repo/profile_repo.dart';
import '../data_source/remote_data_source/profile_remote_data_source.dart';
import '../model/request/update_profile_request_dto.dart';
import '../model/response/get_profile_response_dto.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepoImpl(this._remoteDataSource);

  @override
  Future<BaseResponce<ProfileEntity>> getProfile() async {
    final result = await _remoteDataSource.getProfile();
    return switch (result) {
      SuccessResponce<GetProfileResponseDto>(:final data) =>
        SuccessResponce<ProfileEntity>(data.toDomain()),
      ErrorResponce<GetProfileResponseDto>(:final error) =>
        ErrorResponce<ProfileEntity>(error),
    };
  }

  @override
  Future<BaseResponce<ProfileEntity>> updateProfile(
    ProfileEntity profile,
  ) async {
    final UpdateProfileRequestDto request;
    try {
      request = UpdateProfileRequestDto.fromDomain(profile);
    } catch (e) {
      // e.g. the picked image file no longer exists
      return ErrorResponce<ProfileEntity>(Exception(e.toString()));
    }

    final result = await _remoteDataSource.updateProfile(request);
    return switch (result) {
      SuccessResponce<void>() => await getProfile(),
      ErrorResponce<void>(:final error) => ErrorResponce<ProfileEntity>(error),
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
