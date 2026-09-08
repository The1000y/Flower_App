import 'package:flower_app/config/base/base_responce.dart';

abstract interface class ProfileRepo {
  Future<BaseResponce<bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
