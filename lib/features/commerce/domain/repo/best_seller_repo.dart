import 'package:flower_app/config/base/base_responce.dart';
import '../entities/products/product_entity.dart';

abstract interface class BestSellerRepo {
  Future<BaseResponce<List<ProductEntity>>> getBestSeller({int page = 1});
}
