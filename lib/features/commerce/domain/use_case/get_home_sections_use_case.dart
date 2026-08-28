import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetHomeSectionsUseCase {
  final CommerceRepo commerceRepo;

  GetHomeSectionsUseCase(this.commerceRepo);

  Future<BaseResponce<List<SectionEntity>>> call() async {
    return await commerceRepo.getSection();
  }
}
