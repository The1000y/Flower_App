import 'package:flower_app/config/base/base_responce.dart';
import 'package:injectable/injectable.dart';

import '../entities/products/product_entity.dart';
import '../repo/commerce_repo.dart';

@injectable
class GetProductsUseCase {
  final CommerceRepo _commerceRepo;
  GetProductsUseCase(this._commerceRepo);

  Future<BaseResponce<List<ProductEntity>>> execute(int occasionId) {
    return _commerceRepo.getProducts(occasionId);
  }
}