import 'package:dio/dio.dart';
import 'package:flower_app/features/profile/api/client/profile_api_client.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_responce.dart';
import '../../../data/data_source/remote_data_source/profile_remote_data_source.dart';
import '../../../data/model/request/update_profile_request_dto.dart';
import '../../../data/model/response/get_profile_response_dto.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileApiClient _client;

  ProfileRemoteDataSourceImpl(this._client);

  @override
  Future<BaseResponce<GetProfileResponseDto>> getProfile() async {
    try {
      final response = await _client.getProfile();
      return SuccessResponce<GetProfileResponseDto>(response);
    } on DioException catch (e) {
      return ErrorResponce<GetProfileResponseDto>(e);
    } catch (e) {
      return ErrorResponce<GetProfileResponseDto>(Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<void>> updateProfile(UpdateProfileRequestDto request) async {
    try {
      await _client.updateProfile(
        request.fullName,
        request.email,
        request.phone,
        request.gender,
        request.photo,
      );
      return SuccessResponce<void>(null);
    } on DioException catch (e) {
      return ErrorResponce<void>(e);
    } catch (e) {
      return ErrorResponce<void>(Exception(e.toString()));
    }
  }
}