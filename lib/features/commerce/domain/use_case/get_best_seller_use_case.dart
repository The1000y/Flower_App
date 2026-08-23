import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetBestSeller {
  final CommerceRepo repository;

  GetBestSeller(this.repository);

  Future<List<ProductEntity>> call() {
    return repository.getBestSeller();
  }
}