import '../../../../config/base/base_responce.dart';
import '../entities/occasion/occasion_entity.dart';
import '../entities/products/pagination_entity.dart';
import '../entities/products/product_entity.dart';

abstract interface class CommerceRepo {
  Future<BaseResponce<List<OccasionEntity>>> getOccasions();
  Future<BaseResponce<PaginatedProducts>> getProducts(int occasionId, {int page = 1});
}