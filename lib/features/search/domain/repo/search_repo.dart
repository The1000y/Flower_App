import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';

 abstract interface class SearchRepo {
  Future<BaseResponce<List<ProductEntity>>> searchProduct(String query);
}
