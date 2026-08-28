import 'package:flower_app/config/base/base_responce.dart';
import 'package:injectable/injectable.dart';
import '../entities/product_details/product_details_entity.dart';
import '../repo/product_details_repo.dart';

@injectable
class GetProductDetailsUseCase {
  final ProductDetailsRepo _repository;

  GetProductDetailsUseCase(this._repository);

  Future<BaseResponce<ProductDetailsEntity>> execute(int productId) async {
    return await _repository.getProductDetails(productId);
  }
}
