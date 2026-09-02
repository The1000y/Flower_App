import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/product_Dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRepo)
class CommerceRepoImpl implements CommerceRepo {
  final CommerceLocalDataSource localDataSource;
  CommerceRepoImpl({required this.localDataSource});

  @override
  Future<BaseResponce<List<CategoryEntity>>> getCategories() async {
    final response = await localDataSource.getCategories();

    switch (response) {
      case SuccessResponce<List<CategoryDto>>():
        return SuccessResponce<List<CategoryEntity>>(
          response.data.map((e) => e.toDomain()).toList(),
        );

      case ErrorResponce<List<CategoryDto>>():
        return ErrorResponce(Exception(response.errorMessage));
    }
  }

  @override
  Future<BaseResponce<List<BestSellerEntity>>> getBestSeller() async {
    final response = await localDataSource.getBestSellers();
    switch (response) {
      case SuccessResponce<List<ProductDto>>():
        final data = response.data.map((element) {
          return element.toDomain();
        }).toList();
        return SuccessResponce<List<BestSellerEntity>>(data);

      case ErrorResponce<List<ProductDto>>():
        return ErrorResponce(Exception(response.errorMessage));
    }
  }

  @override
  Future<BaseResponce<List<SectionEntity>>> getSection() async {
    final resopnce = await localDataSource.getSections();
    switch (resopnce) {
      case SuccessResponce<List<SectionDto>>():
        final result = resopnce.data
            .map((element) => element.toDomain())
            .toList();
        return SuccessResponce<List<SectionEntity>>(result);
      case ErrorResponce<List<SectionDto>>():
        return ErrorResponce(Exception(resopnce.errorMessage));
    }
  }

  @override
  Future<BaseResponce<List<OccasionEntity>>> getOccasion() async {
    final response = await localDataSource.getOccasion();

    switch (response) {
      case SuccessResponce<List<OccasionDto>>():
        return SuccessResponce<List<OccasionEntity>>(
          response.data.map((element) => element.toDomain()).toList(),
        );
      case ErrorResponce<List<OccasionDto>>():
        return ErrorResponce(Exception(response.errorMessage));
    }
  }
}
