import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddCartItemUseCase {
  final CommerceRepo _commerceRepo;

  AddCartItemUseCase(this._commerceRepo);

  Future<BaseResponce<CartEntity>> execute(int productId, {int quantity = 1}) async {
    return await _commerceRepo.addCartItem(productId, quantity: quantity);
  }
}
