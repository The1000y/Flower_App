import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteRememberedEmailUseCase {
  final AuthRepo repo;

  DeleteRememberedEmailUseCase(this.repo);

  Future<void> call() => repo.deleteRememberedEmail();
}
