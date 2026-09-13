import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_responce.dart';
import '../../../data/data_source/profile_remote_data_source.dart';
import '../../../data/model/request/update_profile_request_dto.dart';
import '../../../data/model/response/get_profile_response_dto.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

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
}