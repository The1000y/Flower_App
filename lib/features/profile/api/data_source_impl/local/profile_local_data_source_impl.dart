import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/data/data_source/local_data_source/profile_local_data_source.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  Future<BaseResponce<ChangePasswordResponse>> changePassword(
      ChangePasswordRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final response = ChangePasswordResponse(
      data: true,
      isSuccess: true,
      message: 'Password changed successfully',
      errorCode: 200,
    );

    return SuccessResponce<ChangePasswordResponse>(response);
  }
}
