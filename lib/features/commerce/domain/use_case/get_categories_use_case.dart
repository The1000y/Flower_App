import '../../../../config/base/base_responce.dart';
import '../entities/categories/categories_entity.dart';
import '../repo/commerce_repo.dart';

class GetCategoriesUseCase {
  CommerceRepo commerceRepo;
  GetCategoriesUseCase(this.commerceRepo);
  Future<BaseResponce<List<CategoryEntity>>> execute() async {
    BaseResponce<List<CategoryEntity>> response = await commerceRepo
        .getCategories();
    return response;
  }
}
