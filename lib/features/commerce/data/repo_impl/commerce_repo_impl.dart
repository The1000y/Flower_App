import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/remote_data_source/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRepo)
class CommerceRepoImpl implements CommerceRepo {
  final CommerceRemoteDataSource _remoteDataSource;
  CommerceRepoImpl(this._remoteDataSource);

  @override
  Future<BaseResponce<List<OccasionEntity>>> getOccasions() async {
    try {
      final response = await _remoteDataSource.getOccasions();
      if (response.isSuccess) {
        return SuccessResponce(response.toDomain());
      }
      return ErrorResponce(Exception(response.message));
    } catch (error) {
      return ErrorResponce(error is Exception ? error : Exception(error.toString()));
    }
  }

  @override
  Future<BaseResponce<List<ProductEntity>>> getProducts(int occasionId) async {
    try {
      final response = await _remoteDataSource.getProducts(occasionId);
      if (response.isSuccess) {
        return SuccessResponce(response.products);
      }
      return ErrorResponce(Exception(response.message));
    } catch (error) {
      return ErrorResponce(error is Exception ? error : Exception(error.toString()));
    }
  }
}