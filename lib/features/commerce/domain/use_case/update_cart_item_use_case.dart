import 'package:injectable/injectable.dart';

import '../../../../config/base/base_responce.dart';
import '../../data/model/request/cart_request/update_cart_item_request_dto.dart';
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
    UpdateCartItemRequestDto request,
  ) async {
    return await commerceRepo.updateCartItemQuantity(
      cartItemId,
      request,
    );
  }
}