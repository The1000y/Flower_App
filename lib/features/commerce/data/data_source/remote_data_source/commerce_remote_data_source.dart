import '../../model/responce/occasion_response/occasions_response_dto.dart';
import '../../model/responce/products_response/products_response_dto.dart';

abstract interface class CommerceRemoteDataSource {
  Future<OccasionsResponseDto> getOccasions();
  Future<ProductsResponseDto> getProducts(int occasionId);
}