import 'package:flower_app/features/commerce/domain/entities/home/home_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class RefreshSections {
  final CommerceRepo repository;

  RefreshSections(this.repository);

  Future<List<HomeEntity>> call() {
    return repository.refreshSections();
  }
}
