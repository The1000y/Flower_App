import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/item_Dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:mockito/mockito.dart';

/// Registers dummy values for [BaseResponce] generics so Mockito can capture
/// stub invocations without throwing [MissingDummyValueError].
///
/// Call this once at the start of every commerce test's `main()`.
void registerCommerceTestDummies() {
  // Data-layer types.
  provideDummy<BaseResponce<List<CategoryDto>>>(
    SuccessResponce<List<CategoryDto>>(const []),
  );
  provideDummy<BaseResponce<List<ProductDto>>>(
    SuccessResponce<List<ProductDto>>(const []),
  );
  provideDummy<BaseResponce<List<SectionDto>>>(
    SuccessResponce<List<SectionDto>>(const []),
  );

  // Domain-layer types.
  provideDummy<BaseResponce<List<CategoryEntity>>>(
    SuccessResponce<List<CategoryEntity>>(const []),
  );
  provideDummy<BaseResponce<List<BestSellerEntity>>>(
    SuccessResponce<List<BestSellerEntity>>(const []),
  );
  provideDummy<BaseResponce<List<SectionEntity>>>(
    SuccessResponce<List<SectionEntity>>(const []),
  );
  provideDummy<BaseResponce<List<OccasionEntity>>>(
    SuccessResponce<List<OccasionEntity>>(const []),
  );
}
