import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/product_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_details_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/home_section_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details/product_details_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRepo)
class CommerceRepoImpl implements CommerceRepo {
  final CommerceLocalDataSource commerceLocalDataSource;

  CommerceRepoImpl(this.commerceLocalDataSource);

  @override
  Future<BaseResponce<List<CategoryEntity>>> getCategories() async {
    BaseResponce<List<CategoryDto>> response =
        await commerceLocalDataSource.getCategories();
    switch (response) {
      case SuccessResponce<List<CategoryDto>>():
        List<CategoryEntity> categories =
            response.data.map((element) => element.toDomain()).toList();
        return SuccessResponce<List<CategoryEntity>>(categories);
      case ErrorResponce<List<CategoryDto>>():
        return ErrorResponce<List<CategoryEntity>>(response.error);
    }
  }

  @override
  Future<BaseResponce<List<OccasionEntity>>> getOccasions() async {
    BaseResponce<List<OccasionDto>> response =
        await commerceLocalDataSource.getOccasions();
    switch (response) {
      case SuccessResponce<List<OccasionDto>>():
        List<OccasionEntity> occasions =
            response.data.map((element) => element.toDomain()).toList();
        return SuccessResponce<List<OccasionEntity>>(occasions);
      case ErrorResponce<List<OccasionDto>>():
        return ErrorResponce<List<OccasionEntity>>(response.error);
    }
  }

  @override
  Future<BaseResponce<List<ProductEntity>>> getBestSellers() async {
    BaseResponce<List<ProductDto>> response =
        await commerceLocalDataSource.getBestSellers();
    switch (response) {
      case SuccessResponce<List<ProductDto>>():
        List<ProductEntity> products =
            response.data.map((element) => element.toDomain()).toList();
        return SuccessResponce<List<ProductEntity>>(products);
      case ErrorResponce<List<ProductDto>>():
        return ErrorResponce<List<ProductEntity>>(response.error);
    }
  }

  @override
  Future<BaseResponce<List<HomeEntity>>> getHomeSections() async {
    BaseResponce<List<HomeSectionDto>> response =
        await commerceLocalDataSource.getHomeSections();
    switch (response) {
      case SuccessResponce<List<HomeSectionDto>>():
        List<HomeEntity> sections =
            response.data.map((element) => element.toDomain()).toList();
        return SuccessResponce<List<HomeEntity>>(sections);
      case ErrorResponce<List<HomeSectionDto>>():
        return ErrorResponce<List<HomeEntity>>(response.error);
    }
  }

  @override
  Future<BaseResponce<ProductDetailsEntity>> getProductDetails(int id) async {
    BaseResponce<ProductDetailsDto> response =
        await commerceLocalDataSource.getProductDetails(id);
    switch (response) {
      case SuccessResponce<ProductDetailsDto>():
        return SuccessResponce<ProductDetailsEntity>(response.data.toDomain());
      case ErrorResponce<ProductDetailsDto>():
        return ErrorResponce<ProductDetailsEntity>(response.error);
    }
  }

  @override
  Future<BaseResponce<List<ProductEntity>>> searchProducts(String query) async {
    BaseResponce<List<ProductDto>> response =
        await commerceLocalDataSource.searchProducts(query);
    switch (response) {
      case SuccessResponce<List<ProductDto>>():
        List<ProductEntity> products =
            response.data.map((element) => element.toDomain()).toList();
        return SuccessResponce<List<ProductEntity>>(products);
      case ErrorResponce<List<ProductDto>>():
        return ErrorResponce<List<ProductEntity>>(response.error);
    }
  }
}
