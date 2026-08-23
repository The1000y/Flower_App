import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOccasionsPageUseCase {
  final CommerceRepo repository;

  GetOccasionsPageUseCase(this.repository);

  Future<BaseResponce<List<OccasionEntity>>> call() async {
      final occasions = await repository.getOccasions();
      switch(occasions){
        case SuccessResponce<List<OccasionEntity>>():
          return SuccessResponce(occasions.data);
        case ErrorResponce<List<OccasionEntity>>():
          return ErrorResponce(Exception(occasions.error));

      }
    }

}
