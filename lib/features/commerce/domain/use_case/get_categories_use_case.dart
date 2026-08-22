import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetCategories {
  final CommerceRepo repository;

  GetCategories(this.repository);

  Future<List<CategoryEntity>> call() {
    return repository.getCategories();
  }
}