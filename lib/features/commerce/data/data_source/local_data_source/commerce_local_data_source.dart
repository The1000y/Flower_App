import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/product_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';

/// Cart is served exclusively by the remote data source; this local data
/// source intentionally holds no cart data or fallbacks.
abstract interface class CommerceLocalDataSource {
  Future<BaseResponce<List<CategoryDto>>> getCategories();
  Future<BaseResponce<ProductsResponseDto>> getProducts();
  Future<BaseResponce<ProductsResponseDto>> getProductsForOccasion(String occasionId, {int page = 1});
  Future<BaseResponce<List<ProductDto>>> getBestSellers();
  Future<BaseResponce<List<SectionDto>>> getSections();
  Future<BaseResponce<List<OccasionDto>>> getOccasions();
}
