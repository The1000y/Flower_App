import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetOccasions {
  final CommerceRepo repository;

  GetOccasions(this.repository);

  Future<List<OccasionEntity>> call() {
    return repository.getOccasions();
  }
}