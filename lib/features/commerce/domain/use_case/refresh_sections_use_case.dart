import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';
@injectable
class CheckSectionsUpdate {
  final CommerceRepo repository;

  CheckSectionsUpdate(this.repository);

  Future<bool> call() {
    return repository.checkSectionsUpdate();
  }
}