
import '../entities/occasion/occasion_entity.dart';
import '../entities/products/pagination_entity.dart';
import '../entities/products/product_entity.dart';

abstract interface class CommerceRepo {
  Future<List<OccasionEntity>> getOccasions();
  Future<PaginatedProducts> getProducts(int occasionId, {int page = 1});
}