import 'package:flower_app/config/base/base_responce.dart';

import '../entities/products/product_entity.dart';
import '../repo/commerce_repo.dart';

class GetProductDetailsUseCase {
    CommerceRepo commerceRepo;
    GetProductDetailsUseCase(this.commerceRepo);
    Future<BaseResponce<ProductEntity>> execute() async {
        BaseResponce<ProductEntity> response = await commerceRepo.getProducts();
        return response;
    }

}