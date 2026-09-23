import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/product_details_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_details_response_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details/product_details_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/product_details_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductDetailsRepo)
class ProductDetailsRepoImpl implements ProductDetailsRepo {
  final ProductDetailsLocalDataSource _localDataSource;

  ProductDetailsRepoImpl(this._localDataSource);

  @override
  Future<BaseResponce<ProductDetailsEntity>> getProductDetails(int productId) async {
    final response = await _localDataSource.getProductDetails(productId);
    switch (response) {
      case SuccessResponce<ProductDetailsResponseDto>():
        return SuccessResponce<ProductDetailsEntity>(response.data.data.toDomain());
      case ErrorResponce<ProductDetailsResponseDto>():
        return ErrorResponce<ProductDetailsEntity>(response.error);
    }
  }
}
