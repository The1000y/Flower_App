import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetHomeSectionsUseCase {
  final CommerceRepo commerceRepo;

  GetHomeSectionsUseCase(this.commerceRepo);

  Future<BaseResponce<List<SectionEntity>>> call() async {
    final result = await commerceRepo.getSection();
    switch (result) {
      case SuccessResponce<List<SectionEntity>>():
        List<SectionEntity> sortList = result.data;
        sortList.sort((a, b) => a.index.compareTo(b.index));
        final activeSections = sortList
            .where((element) => element.isActive == true)
            .toList();
        return SuccessResponce<List<SectionEntity>>(activeSections);

      case ErrorResponce<List<SectionEntity>>():
        return ErrorResponce(Exception(result.errorMessage));
    }
  }
}
