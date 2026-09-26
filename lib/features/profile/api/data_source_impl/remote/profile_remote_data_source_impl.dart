import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/api/client/profile_api_client.dart';
import 'package:flower_app/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileApiClient _apiClient;

  ProfileRemoteDataSourceImpl(this._apiClient);

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
