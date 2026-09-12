
import 'package:flower_app/features/commerce/domain/models/cart/update_cart_item_params.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base/base_responce.dart';
import '../entities/cart/cart_entity.dart';
import '../repo/commerce_repo.dart';

@injectable
class UpdateCartItemUseCase {
  final CommerceRepo commerceRepo;

  UpdateCartItemUseCase({
    required this.commerceRepo,
  });

  Future<BaseResponce<CartEntity>> call(
    String cartItemId,
    UpdateCartItemParams params,
  ) async {
    return await commerceRepo.updateCartItemQuantity(
      cartItemId,
      params,
    );
  }
}

