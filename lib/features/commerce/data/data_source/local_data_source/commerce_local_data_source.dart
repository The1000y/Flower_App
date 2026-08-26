import '../../../../../config/base/base_responce.dart';
import '../../model/responce/occasion_response/occasion_dto.dart';
import '../../model/responce/products_response/products_response_dto.dart';

abstract interface class CommerceLocalDataSource {
  Future<BaseResponce<List<OccasionDto>>> getOccasions();
  Future<BaseResponce<ProductsResponseDto>> getProducts(int occasionId, {int page = 1});
}