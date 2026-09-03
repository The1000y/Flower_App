import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/categories_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';

abstract interface class CommerceRemoteDataSource {
  Future<BaseResponce<List<OccasionDto>>> getOccasions();
  Future<BaseResponce<ProductsResponseDto>> getProducts(int occasionId, {int page = 1});
  Future<BaseResponce<List<CategoriesResponseDto>>> getCategories();
}
