import '../../../../../config/base/base_responce.dart';
import '../../model/request/update_profile_request_dto.dart';
import '../../model/response/get_profile_response_dto.dart';

abstract interface class ProfileRemoteDataSource {
  Future<BaseResponce<GetProfileResponseDto>> getProfile();
  Future<BaseResponce<void>> updateProfile(UpdateProfileRequestDto request);
}