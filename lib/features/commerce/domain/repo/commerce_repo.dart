import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';

abstract interface class CommerceRepo {
  Future<BaseResponce<List<CategoryEntity>>> getCategories();
  Future<BaseResponce<List<BestSellerEntity>>> getBestSeller();
  Future<BaseResponce<List<SectionEntity>>> getSection();
  Future<BaseResponce<List<OccasionEntity>>> getOccasions();
  Future<BaseResponce<List<ProductEntity>>> getProducts();
  Future<BaseResponce<PaginatedProducts>> getOccasionsProducts(int occasionId, {int page = 1});
}
