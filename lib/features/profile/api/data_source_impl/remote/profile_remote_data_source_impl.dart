import 'package:dio/dio.dart';
import 'package:flower_app/features/profile/api/client/profile_api_client.dart';
import 'package:flower_app/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_responce.dart';

import '../../../data/model/request/update_profile_request_dto.dart';
import '../../../data/model/response/get_profile_response_dto.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;
  final ProfileApiClient _apiClient;
  ProfileRemoteDataSourceImpl(this._dio, this._apiClient);

  @override
  Future<BaseResponce<GetProfileResponseDto>> getProfile() async {
    try {
      final response = await _dio.get('/users/me');
      return SuccessResponce(GetProfileResponseDto.fromJson(response.data));
    } on DioException catch (e) {
      return ErrorResponce(e);
    } catch (e) {
      return ErrorResponce(Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<GetProfileResponseDto>> updateProfile(UpdateProfileRequestDto request) async {
    try {
      final response = await _dio.put('/users/me', data: request.toJson());
      return SuccessResponce(GetProfileResponseDto.fromJson(response.data));
    } on DioException catch (e) {
      return ErrorResponce(e);
    } catch (e) {
      return ErrorResponce(Exception(e.toString()));
    }
  }


   @override
  Future<BaseResponce<ChangePasswordResponse>> changePassword(
      ChangePasswordRequest request) async {
    try {
      final response = await _apiClient.changePassword(request);
      return SuccessResponce<ChangePasswordResponse>(response);
    } on Exception catch (e) {
      return ErrorResponce<ChangePasswordResponse>(e);
    }
  }
}