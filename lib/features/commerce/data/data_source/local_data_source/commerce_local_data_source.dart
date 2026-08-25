import 'package:flower_app/config/base/base_responce.dart';

import '../../model/responce/categories_response/categories_response_dto.dart';
import '../../model/responce/products_response/products_response_dto.dart';

abstract interface class CommerceLocalDataSource {
   Future<BaseResponce<List<CategoriesResponseDto>>> getCategories();

  Future<BaseResponce<ProductsResponseDto>> getProducts();
}