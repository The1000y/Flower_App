import 'package:injectable/injectable.dart';

import '../../../../config/base/base_responce.dart';
import '../../data/model/request/cart_request/add_cart_item_request_dto.dart';
import '../entities/cart/cart_entity.dart';
import '../repo/commerce_repo.dart';
@injectable
class AddCartItemUseCase {
    CommerceRepo commerceRepo;
AddCartItemUseCase({required this.commerceRepo});

  Future<BaseResponce<CartEntity>> call(AddCartItemRequestDto request) async {
    return await commerceRepo.addToCart(request);
  }
}