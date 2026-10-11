import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/product_details_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_details_response_dto.dart';
import 'package:flower_app/features/commerce/api/client/commerce_api_client.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductDetailsLocalDataSource)
class ProductDetailsLocalDataSourceImpl
    implements ProductDetailsLocalDataSource {
  final CommerceApiClient _apiClient;

  ProductDetailsLocalDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponce<ProductDetailsResponseDto>> getProductDetails(
    String productId,
  ) async {
    try {
      final response = await _apiClient.getProductDetails(productId);
      return SuccessResponce(response);
    } catch (e) {
      return ErrorResponce(Exception(e.toString()));
    }
  }
}
