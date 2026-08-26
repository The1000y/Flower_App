import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/remote_data_source/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasions_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
import 'package:injectable/injectable.dart';

import '../../../data/model/responce/occasion_response/occasion_dto.dart';
import '../../../data/model/responce/products_response/product_dto.dart';
import '../../client/home_api_client.dart';
import 'occasion_dummy_data.dart';

@LazySingleton(as: CommerceRemoteDataSource)
class RemoteDataSourceImpl implements CommerceRemoteDataSource {
  final HomeApi homeApi;
  RemoteDataSourceImpl(this.homeApi);

  @override
  Future<BaseResponce<List<OccasionDto>>> getOccasions() async {
    try {
      final json = OccasionDummyData.occasions;
      final dtoList = (json['data'] as List)
          .map((item) => OccasionDto.fromJson(item as Map<String, dynamic>))
          .toList();
      return SuccessResponce(dtoList);
    } catch (e) {
      return ErrorResponce(Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<ProductsResponseDto>> getProducts(int occasionId, {int page = 1}) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final dto = ProductsResponseDto.fromJson(OccasionDummyData.products);
      return SuccessResponce(dto);
    } catch (e) {
      return ErrorResponce(Exception(e.toString()));
    }
  }
}