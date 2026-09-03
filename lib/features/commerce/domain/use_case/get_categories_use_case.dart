import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCategoriesUseCase {
  CommerceRepo commerceRepo;

  GetCategoriesUseCase({required this.commerceRepo});

  Future<BaseResponce<List<CategoryEntity>>> call() async {
    return await commerceRepo.getCategories();
  }
}
