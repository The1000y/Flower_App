import 'package:injectable/injectable.dart';
import '../repo/auth_repo.dart';

@injectable
class CheckLoggedInAuthUseCase {
  final AuthRepo _authRepo;

  CheckLoggedInAuthUseCase(this._authRepo);

  Future<bool> execute() async {
    return await _authRepo.isLoggedIn();
  }
}
