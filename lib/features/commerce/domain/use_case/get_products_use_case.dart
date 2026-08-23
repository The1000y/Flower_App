import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductsUseCase {
  final CommerceRepo _commerceRepo;

  GetProductsUseCase(this._commerceRepo);

  Future<BaseResponce<List<ProductEntity>>> call(int occasionId) async {
    try {
      final products = await _commerceRepo.getSectionProducts(
        occasionId: occasionId,
      );
      return SuccessResponce(products);
    } on ErrorResponce catch (error) {
      return ErrorResponce(error.error);
    } catch (error) {
      return ErrorResponce(
        error is Exception ? error : Exception(error.toString()),
      );
    }
  }
}
