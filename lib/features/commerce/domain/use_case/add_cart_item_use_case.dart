import 'package:flower_app/features/commerce/domain/models/cart/add_cart_item_params.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base/base_responce.dart';
import '../entities/cart/cart_entity.dart';
import '../repo/commerce_repo.dart';

@injectable
class AddCartItemUseCase {
  final CommerceRepo commerceRepo;

  AddCartItemUseCase({required this.commerceRepo});

  Future<BaseResponce<CartEntity>> call(AddCartItemParams params) async {
    return await commerceRepo.addToCart(params);
  }
}
