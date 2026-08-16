import 'package:flower_app/config/base/base_responce.dart';
import 'package:injectable/injectable.dart';
import '../../data/model/request/register_request/register_request.dart';
import '../entities/register_entity/register_entity.dart';

import '../repo/auth_repo.dart';

@injectable
class RegisterAuthUseCase {
  final AuthRepo _authRepo;
  RegisterAuthUseCase(this._authRepo);

  Future<BaseResponce<RegisterEntity>> execute(RegisterRequest  request) async {
    return await _authRepo.register(request);
  }
}
