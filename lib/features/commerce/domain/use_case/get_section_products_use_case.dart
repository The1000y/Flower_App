import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSectionProducts {
  final CommerceRepo repository;

  GetSectionProducts(this.repository);

  Future<List<ProductEntity>> call({
    int? occasionId,
    int? categoryId,
  }) {
    return repository.getSectionProducts(
      occasionId: occasionId,
      categoryId: categoryId,
    );
  }
}
