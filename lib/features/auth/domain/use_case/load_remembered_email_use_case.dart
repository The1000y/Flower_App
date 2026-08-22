import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoadRememberedEmailUseCase {
  final AuthRepo repo;

  LoadRememberedEmailUseCase(this.repo);

  Future<String?> call() => repo.getRememberedEmail();
}
