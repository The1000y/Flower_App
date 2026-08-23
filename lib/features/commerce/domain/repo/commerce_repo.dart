import 'package:flower_app/config/base/base_responce.dart';

import '../entities/occasion/occasion_entity.dart';
import '../entities/products/product_entity.dart';

abstract interface class CommerceRepo {
  Future<BaseResponce<List<OccasionEntity>>> getOccasions();
  Future<BaseResponce<List<ProductEntity>>> getProducts(int occasionId);
}