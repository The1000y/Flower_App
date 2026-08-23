import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';

abstract interface class CommerceLocalDataSource {
  Future<BaseResponce<List<CategoryDto>>> getCategories();
}
