import 'package:injectable/injectable.dart';

import '../../../../config/base/base_responce.dart';
import '../entities/categories/categories_entity.dart';
import '../repo/commerce_repo.dart';
@injectable

class GetCategoriesUseCase {
  CommerceRepo commerceRepo;
  GetCategoriesUseCase(this.commerceRepo);
  Future<BaseResponce<List<CategoryEntity>>> call() async {
    BaseResponce<List<CategoryEntity>> response = await commerceRepo
        .getCategories();
    return response;
  }
}
