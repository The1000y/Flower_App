import 'package:flower_app/config/base/base_responce.dart';
import '../../model/responce/product_details_response/product_details_response_dto.dart';

abstract interface class ProductDetailsLocalDataSource {
  Future<BaseResponce<ProductDetailsResponseDto>> getProductDetails(int productId);
}