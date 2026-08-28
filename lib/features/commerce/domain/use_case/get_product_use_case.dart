import 'package:flower_app/config/base/base_responce.dart';
import 'package:injectable/injectable.dart';

import '../entities/products/product_entity.dart';
import '../repo/commerce_repo.dart';
@injectable

class GetProductUseCase {
  CommerceRepo commerceRepo;
  GetProductUseCase(this.commerceRepo);
  Future<BaseResponce<List<ProductEntity>>> call() async {
    BaseResponce<List<ProductEntity>> response = await commerceRepo
        .getProducts();
    return response;
  }
}
