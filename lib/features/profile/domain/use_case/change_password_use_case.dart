import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordUseCase {
  final ProfileRepo profileRepo;

  ChangePasswordUseCase(this.profileRepo);

  Future<BaseResponce<ChangePasswordResponse>> call(ChangePasswordRequest request) async {
    return await profileRepo.changePassword(request);
  }
}
