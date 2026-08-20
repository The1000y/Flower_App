import 'package:flower_app/config/base/base_responce.dart';
import 'package:injectable/injectable.dart';
import '../entities/register_entity/register_entity.dart';
import '../entities/register_entity/register_request_entity.dart';

import '../repo/auth_repo.dart';

@injectable
class RegisterAuthUseCase {
  final AuthRepo _authRepo;
  RegisterAuthUseCase(this._authRepo);

  Future<BaseResponce<RegisterEntity>> execute(RegisterRequestEntity request) async {
    final error = request.validate();
    if (error != null) {
      return ErrorResponce<RegisterEntity>(Exception(error));
    }
    return await _authRepo.register(request);
  }
}