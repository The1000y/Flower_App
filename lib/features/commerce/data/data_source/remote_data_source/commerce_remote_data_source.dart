import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/categories_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';

abstract class CommerceRemoteDataSource {
  Future<BaseResponce<List<CategoriesResponseDto>>> getCategories();

  Future<BaseResponce<ProductsResponseDto>> getProducts();
}