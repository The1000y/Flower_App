import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/product_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_details_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/home_section_dto.dart';

abstract interface class CommerceLocalDataSource {
  Future<BaseResponce<List<CategoryDto>>> getCategories();
  Future<BaseResponce<List<OccasionDto>>> getOccasions();
  Future<BaseResponce<List<ProductDto>>> getBestSellers();
  Future<BaseResponce<List<HomeSectionDto>>> getHomeSections();
  Future<BaseResponce<ProductDetailsDto>> getProductDetails(int id);
  Future<BaseResponce<List<ProductDto>>> searchProducts(String query);
}
