import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/remote_data_source/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/products/pagination_entity.dart';
import '../model/responce/occasion_response/occasion_dto.dart';
import '../model/responce/products_response/products_response_dto.dart';

@Injectable(as: CommerceRepo)
class CommerceRepoImpl implements CommerceRepo {
  final CommerceRemoteDataSource remoteDataSource;
  CommerceRepoImpl(this.remoteDataSource);

  @override
  Future<BaseResponce<List<OccasionEntity>>> getOccasions() async {
    final response = await remoteDataSource.getOccasions();

    switch (response) {
      case SuccessResponce<List<OccasionDto>>():
        return SuccessResponce(response.data.map((e) => e.toDomain()).toList());
      case ErrorResponce<List<OccasionDto>>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<PaginatedProducts>> getProducts(int occasionId, {int page = 1}) async {
    final response = await remoteDataSource.getProducts(occasionId, page: page);

    switch (response) {
      case SuccessResponce<ProductsResponseDto>():
        return SuccessResponce(PaginatedProducts(
          items: response.data.products,
          pagination: response.data.pagination,
        ));
      case ErrorResponce<ProductsResponseDto>():
        return ErrorResponce(response.error);
    }
  }
}