import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateCartItemUseCase {
  final CommerceRepo _commerceRepo;

  UpdateCartItemUseCase(this._commerceRepo);

  Future<BaseResponce<CartEntity>> execute(int productId, int quantity) async {
    return await _commerceRepo.updateCartItem(productId, quantity);
  }
}
