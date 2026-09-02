import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/product_Dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';

abstract interface class CommerceLocalDataSource {
  Future<BaseResponce<List<CategoryDto>>> getCategories();
  Future<BaseResponce<List<ProductDto>>> getBestSellers();
  Future<BaseResponce<List<SectionDto>>> getSections();
  Future<BaseResponce<List<OccasionDto>>> getOccasion();
}
