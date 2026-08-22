import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/bestSeller/product_entity.dart';

abstract interface class CommerceRepo {
   Future<List<HomeEntity>> getSections();

  Future<List<CategoryEntity>> getCategories();

  Future<List<BestSellerEntity>> getBestSeller();

  Future<List<OccasionEntity>> getOccasions();

  Future<bool> checkSectionsUpdate();

  Future<List<HomeEntity>> refreshSections();
}