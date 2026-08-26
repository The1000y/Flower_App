import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOccasionsUseCase {
  CommerceRepo commerceRepo;
  GetOccasionsUseCase(this.commerceRepo);

  Future<BaseResponce<List<OccasionEntity>>> call() async {
    return await commerceRepo.getOccasion();
  }
}
