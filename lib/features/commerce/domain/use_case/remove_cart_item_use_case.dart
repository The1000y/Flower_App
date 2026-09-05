import 'package:injectable/injectable.dart';

import '../../../../config/base/base_responce.dart';
import '../entities/cart/cart_entity.dart';
import '../repo/commerce_repo.dart';
@injectable
class RemoveCartItemUseCase {
    CommerceRepo commerceRepo;
RemoveCartItemUseCase({required this.commerceRepo});

  Future<BaseResponce<CartEntity>> call(String cartItemId) async {
    return await commerceRepo.removeCartItem(cartItemId);
  }
}