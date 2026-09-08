import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/data/data_source/local_data_source/profile_local_data_source.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileLocalDataSource localDataSource;

  ProfileRepoImpl(this.localDataSource);

  @override
  Future<BaseResponce<ChangePasswordResponse>> changePassword(ChangePasswordRequest request) async {
    return await localDataSource.changePassword(request);
  }
}
