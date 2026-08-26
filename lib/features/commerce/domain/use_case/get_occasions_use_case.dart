import 'package:flower_app/config/base/base_responce.dart';
import 'package:injectable/injectable.dart';

import '../entities/occasion/occasion_entity.dart';
import '../repo/commerce_repo.dart';

@injectable
class GetOccasionsUseCase {
  final CommerceRepo repository;
  GetOccasionsUseCase(this.repository);

  Future<List<OccasionEntity>> execute() {
    return repository.getOccasions();
  }
}