import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/remote_data_source/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/products/pagination_entity.dart';
import '../model/responce/occasion_response/occasion_dto.dart';
import '../model/responce/products_response/product_dto.dart';
import '../model/responce/products_response/products_response_dto.dart';

@Injectable(as: CommerceRepo)
class CommerceRepoImpl implements CommerceRepo {
  final CommerceRemoteDataSource remoteDataSource;
  CommerceRepoImpl(this.remoteDataSource);

  @override
  Future<List<OccasionEntity>> getOccasions() async {
    final response = await remoteDataSource.getOccasions();

    switch (response) {
      case SuccessResponce<List<OccasionDto>>():
        return response.data.map((e) => e.toDomain()).toList();

      case ErrorResponce<List<OccasionDto>>():
        throw ErrorResponce(Exception(response.errorMessage));
    }
  }

  @override
  Future<PaginatedProducts> getProducts(int occasionId, {int page = 1}) async {
    final response = await remoteDataSource.getProducts(occasionId, page: page);

    switch (response) {
      case SuccessResponce<ProductsResponseDto>():
        return PaginatedProducts(
          items: response.data.products,
          pagination: response.data.pagination,
        );
      case ErrorResponce<ProductsResponseDto>():
        throw ErrorResponce(Exception(response.errorMessage));
    }
  }

}














//import 'package:flower_app/config/base/base_responce.dart';
// import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
// import 'package:flower_app/features/commerce/data/model/responce/categories_response/categories_response_dto.dart';
// import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
// import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
// import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
// import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
// import 'package:injectable/injectable.dart';
//
// @Injectable(as: CommerceRepo)
// class CommerceRepoImpl implements CommerceRepo {
//   CommerceLocalDataSource commerceLocalDataSource;
//   CommerceRepoImpl(this.commerceLocalDataSource);
//   @override
//   Future<BaseResponce<List<CategoryEntity>>> getCategories() async {
//     final BaseResponce<List<CategoriesResponseDto>> response =
//         await commerceLocalDataSource.getCategories();
//     switch (response) {
//       case SuccessResponce<List<CategoriesResponseDto>>():
//         final List<CategoryEntity> categoryEntityList = response.data
//             .expand((dto) => dto.toDomain())
//             .toList();
//         return SuccessResponce<List<CategoryEntity>>(categoryEntityList);
//       case ErrorResponce<List<CategoriesResponseDto>>():
//         return ErrorResponce<List<CategoryEntity>>(response.error);
//     }
//   }
//
//   @override
//   Future<BaseResponce<List<ProductEntity>>> getProducts() async {
//     final BaseResponce<ProductsResponseDto> response =
//         await commerceLocalDataSource.getProducts();
//
//     switch (response) {
//       case SuccessResponce<ProductsResponseDto>():
//         return SuccessResponce<List<ProductEntity>>(response.data.products);
//       case ErrorResponce<ProductsResponseDto>():
//         return ErrorResponce<List<ProductEntity>>(response.error);
//     }
//   }
// }