import 'package:flower_app/config/base/base_state.dart';

import '../../../../domain/entities/cart/cart_entity.dart';

class CartState extends BaseState<CartEntity> {
  const CartState({super.isLoading, super.errorMessage, super.data});

  CartEntity get cart =>
      data ??
      CartEntity(items: const [], subtotal: 0, total: 0, hasChanges: false);

  @override
  CartState copyWith({
    bool? isLoading,
    String? errorMessage,
    CartEntity? data,
  }) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }
}
