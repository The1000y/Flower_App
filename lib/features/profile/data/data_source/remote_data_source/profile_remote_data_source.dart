import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/request/update_profile_request_dto.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:flower_app/features/profile/data/model/response/get_profile_response_dto.dart';

abstract interface class ProfileRemoteDataSource {
  Future<BaseResponce<ChangePasswordResponse>> changePassword(ChangePasswordRequest request);
  Future<BaseResponce<GetProfileResponseDto>> getProfile();
  Future<BaseResponce<GetProfileResponseDto>> updateProfile(UpdateProfileRequestDto request);
}
