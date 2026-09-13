import 'package:injectable/injectable.dart';

import '../../../../config/base/base_responce.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repo/profile_repo.dart';
import '../data_source/profile_remote_data_source.dart';
import '../model/request/update_profile_request_dto.dart';
import '../model/response/get_profile_response_dto.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepoImpl(this._remoteDataSource);

  @override
  Future<BaseResponce<ProfileEntity>> getProfile() async {
    final response = await _remoteDataSource.getProfile();

    return switch (response) {
      SuccessResponce<GetProfileResponseDto>() => SuccessResponce(response.data.toDomain()),
      ErrorResponce<GetProfileResponseDto>() => ErrorResponce(response.error),
    };
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
}