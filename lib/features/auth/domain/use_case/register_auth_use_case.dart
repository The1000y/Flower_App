import 'package:injectable/injectable.dart';
import '../entities/register_entity/auth_entity.dart';
import '../entities/register_entity/register_params.dart';
import '../repo/auth_repo.dart';

@injectable
class RegisterAuthUseCase {
  final AuthRepo _authRepo;
  RegisterAuthUseCase(this._authRepo);

  Future<AuthEntity> execute(RegisterParams params) async {
    return await _authRepo.register(params);
  }
}
