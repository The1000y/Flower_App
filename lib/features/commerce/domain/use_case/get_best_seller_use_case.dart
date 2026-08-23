import 'package:flower_app/config/base/base_responce.dart';
import 'package:injectable/injectable.dart';
import '../entities/products/product_entity.dart';
import '../repo/best_seller_repo.dart';

@injectable
class GetBestSellerUseCase {
  final BestSellerRepo _repository;

  GetBestSellerUseCase(this._repository);

  Future<BaseResponce<List<ProductEntity>>> execute({int page = 1}) async {
    return await _repository.getBestSeller(page: page);
  }
}
