import 'package:injectable/injectable.dart';

import '../../../../config/base/base_responce.dart';
import '../entities/cart/cart_entity.dart';
import '../repo/commerce_repo.dart';
@injectable
class GetCartUseCase {
  CommerceRepo commerceRepo;
  GetCartUseCase({required this.commerceRepo});
  Future<BaseResponce<CartEntity>> call() async {
    return await commerceRepo.getCart();
  }
}