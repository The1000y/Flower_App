import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveRememberedEmailUseCase {
  final AuthRepo repo;

  SaveRememberedEmailUseCase(this.repo);

  Future<void> call(String email) => repo.saveRememberedEmail(email);
}
