import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClearCartUseCase {
  final CommerceRepo commerceRepo;

  ClearCartUseCase({required this.commerceRepo});

  Future<BaseResponce<CartEntity>> call() async {
    return commerceRepo.clearCart();
  }
}
