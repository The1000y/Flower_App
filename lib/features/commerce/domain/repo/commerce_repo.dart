import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details/product_details_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_entity.dart';

abstract interface class CommerceRepo {
  Future<BaseResponce<List<CategoryEntity>>> getCategories();
  Future<BaseResponce<List<OccasionEntity>>> getOccasions();
  Future<BaseResponce<List<ProductEntity>>> getBestSellers();
  Future<BaseResponce<List<HomeEntity>>> getHomeSections();
  Future<BaseResponce<ProductDetailsEntity>> getProductDetails(int id);
  Future<BaseResponce<List<ProductEntity>>> searchProducts(String query);
}