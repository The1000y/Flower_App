import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/data/data_source/local_data_source/profile_local_data_source.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  Future<BaseResponce<ChangePasswordResponse>> changePassword(ChangePasswordRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (request.currentPassword == null || request.currentPassword!.isEmpty) {
      return ErrorResponce<ChangePasswordResponse>(Exception('Current password cannot be empty'));
    }

    if (request.newPassword == null || request.newPassword!.isEmpty) {
      return ErrorResponce<ChangePasswordResponse>(Exception('New password cannot be empty'));
    }

    if (request.newPassword != request.confirmNewPassword) {
      return ErrorResponce<ChangePasswordResponse>(Exception('Passwords do not match'));
    }

    final response = ChangePasswordResponse(
      data: true,
      isSuccess: true,
      message: 'Password changed successfully',
      errorCode: 200,
    );

    return SuccessResponce<ChangePasswordResponse>(response);
  }
}
