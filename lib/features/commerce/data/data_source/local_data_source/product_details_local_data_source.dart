import '../../model/responce/product_details_response/product_details_response_dto.dart';

abstract interface class ProductDetailsLocalDataSource {
  Future<ProductDetailsResponseDto> getProductDetails(int productId);
}