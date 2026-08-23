import 'package:flower_app/config/base/base_responce.dart';

import '../entities/occasion/occasion_entity.dart';
import '../entities/products/product_entity.dart';


import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/bestSeller/product_entity.dart';

abstract interface class CommerceRepo {
   Future<List<HomeEntity>> getSections();

  Future<List<CategoryEntity>> getCategories();

  Future<List<BestSellerEntity>> getBestSeller();

  Future<List<OccasionEntity>> getOccasionsHome();

  Future<bool> checkSectionsUpdate();

  Future<List<HomeEntity>> refreshSections();

  Future<List<BestSellerEntity>> getSectionProducts({
    int? occasionId,
    int? categoryId,
  });

   Future<BaseResponce<List<OccasionEntity>>> getOccasions();
  Future<BaseResponce<List<ProductEntity>>> getProducts(int occasionId);
}