import 'package:flower_app/config/base/base_responce.dart';
import '../entities/product_details/product_details_entity.dart';

abstract interface class ProductDetailsRepo {
  Future<BaseResponce<ProductDetailsEntity>> getProductDetails(int productId);
}
