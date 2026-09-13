import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';

abstract interface class ProfileRemoteDataSource {
  Future<BaseResponce<ChangePasswordResponse>> changePassword(ChangePasswordRequest request);
}
