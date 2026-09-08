import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  @override
  Future<BaseResponce<bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      return SuccessResponce<bool>(true);
    } on Exception catch (e) {
      return ErrorResponce<bool>(e);
    }
  }
}
