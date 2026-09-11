import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/remote_data_source/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/categories_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/pagination_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
import 'package:injectable/injectable.dart';

import '../../../data/model/responce/occasion_response/occasion_dto.dart';
import '../../client/commerce_api_client.dart';
import 'occasion_dummy_data.dart';

@Injectable(as: CommerceRemoteDataSource)
class RemoteDataSourceImpl implements CommerceRemoteDataSource {
  final CommerceApiClient commerceApi;
  RemoteDataSourceImpl(this.commerceApi);

  @override
  Future<BaseResponce<List<OccasionDto>>> getOccasions() async {
    try {
      final json = OccasionDummyData.occasions;
      final dtoList = (json['data'] as List)
          .map((item) => OccasionDto.fromJson(item as Map<String, dynamic>))
          .toList();
      return SuccessResponce(dtoList);
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<ProductsResponseDto>> getProducts(int occasionId, {int page = 1}) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final fullDto = ProductsResponseDto.fromJson(OccasionDummyData.products);
      final allItems = fullDto.data.items;
      final pageSize = fullDto.data.pagination.pageSize;

      final start = (page - 1) * pageSize;
      final end = start + pageSize > allItems.length ? allItems.length : start + pageSize;
      final pageItems = start >= allItems.length
          ? <dynamic>[]
          : allItems.sublist(start, end);

      final totalPages = (allItems.length / pageSize).ceil();

      final dto = ProductsResponseDto(
        data: ProductListDataDto(
          items: pageItems.cast(),
          pagination: PaginationDto(
            page: page,
            pageSize: pageSize,
            totalCount: allItems.length,
            totalPages: totalPages,
            hasNextPage: end < allItems.length,
            hasPreviousPage: page > 1,
          ),
        ),
        isSuccess: true,
        message: '',
        errorCode: 'None',
      );

      return SuccessResponce(dto);
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<List<CategoriesResponseDto>>> getCategories() async {
    return SuccessResponce([]);
  }
}
