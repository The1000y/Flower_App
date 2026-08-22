import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';

abstract interface class CommerceRepo {
  Future<BaseResponce<List<CategoryEntity>>> getCategories();

  Future<BaseResponce<ProductEntity>> getProducts();
}