import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/best_seller_item_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/home_section_data_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';

abstract interface class CommerceRemoteDataSource {
  Future<BaseResponce<List<HomeSectionDto>>> getSections();

  Future<BaseResponce<List<CategoryDto>>> getCategories();

  Future<BaseResponce <List<ItemDto>>> getBestSeller(
    
  );

  Future<BaseResponce<List<OccasionDto>>> getOccasions();

  Future<BaseResponce<List<ItemDto>>> getSectionProducts({
    int? occasionId,
    int? categoryId,
  });
}
