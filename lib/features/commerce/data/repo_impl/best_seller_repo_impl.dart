import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/best_seller_local_data_source.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/best_seller_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BestSellerRepo)
class BestSellerRepoImpl implements BestSellerRepo {
  final BestSellerLocalDataSource _localDataSource;

  BestSellerRepoImpl(this._localDataSource);

  @override
  Future<BaseResponce<List<ProductEntity>>> getBestSeller({int page = 1}) async {
    try {
      final response = await _localDataSource.getBestSeller(page: page);
      if (response.isSuccess) {
        return SuccessResponce(response.products);
      }
      return ErrorResponce(Exception(response.message));
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }
}
