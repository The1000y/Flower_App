import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';

import '../../../../config/base/base_responce.dart';

abstract interface class CommerceRepo {
  Future<List<HomeEntity>> getSections();

  Future<List<CategoryEntity>> getCategories();

  Future<List<ProductEntity>> getBestSeller();

  Future<List<OccasionEntity>> getOccasionsHome();

  Future<bool> checkSectionsUpdate();

  Future<List<HomeEntity>> refreshSections();

  Future<List<ProductEntity>> getSectionProducts({
    int? occasionId,
    int? categoryId,
  });
  Future<BaseResponce<List<OccasionEntity>>> getOccasions();

}
