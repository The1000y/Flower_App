import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/categories_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRepo)
class CommerceRepoImpl implements CommerceRepo {
  CommerceLocalDataSource commerceLocalDataSource;
  CommerceRepoImpl(this.commerceLocalDataSource);
  @override
  Future<BaseResponce<List<CategoryEntity>>> getCategories() async {
    final BaseResponce<List<CategoriesResponseDto>> response =
        await commerceLocalDataSource.getCategories();
    switch (response) {
      case SuccessResponce<List<CategoriesResponseDto>>():
        final List<CategoryEntity> categoryEntityList = response.data
            .expand((dto) => dto.toDomain())
            .toList();
        return SuccessResponce<List<CategoryEntity>>(categoryEntityList);
      case ErrorResponce<List<CategoriesResponseDto>>():
        return ErrorResponce<List<CategoryEntity>>(response.error);
    }
  }

  @override
  Future<BaseResponce<List<ProductEntity>>> getProducts() async {
    final BaseResponce<ProductsResponseDto> response =
        await commerceLocalDataSource.getProducts();

    switch (response) {
      case SuccessResponce<ProductsResponseDto>():
        return SuccessResponce<List<ProductEntity>>(response.data.products);
      case ErrorResponce<ProductsResponseDto>():
        return ErrorResponce<List<ProductEntity>>(response.error);
    }
  }
}
