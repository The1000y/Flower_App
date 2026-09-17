import '../../model/responce/products_response/products_response_dto.dart';

abstract interface class BestSellerLocalDataSource {
  Future<ProductsResponseDto> getBestSeller({int page = 1});
}
