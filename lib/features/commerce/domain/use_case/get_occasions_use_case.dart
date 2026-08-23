import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOccasionsUseCase {
  final CommerceRepo repository;

  GetOccasionsUseCase(this.repository);

  Future<BaseResponce<List<OccasionEntity>>> call() async {
    try {
      final occasions = await repository.getOccasionsHome();
      return SuccessResponce(occasions);
    } on ErrorResponce catch (error) {
      return ErrorResponce(error.error);
    } catch (error) {
      return ErrorResponce(
        error is Exception ? error : Exception(error.toString()),
      );
    }
  }
}
