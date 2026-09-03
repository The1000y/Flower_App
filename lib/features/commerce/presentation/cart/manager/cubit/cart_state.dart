import 'package:equatable/equatable.dart';

import '../../../../domain/entities/cart/cart_item_entity.dart';

class CartState extends Equatable {
  final List<CartItemEntity> cartItems;
  final double totalPrice;
  final bool isLoading;
  final String errorMessage;

  const CartState({
    this.cartItems = const [],
    this.totalPrice = 0.0,
    this.isLoading = false,
    this.errorMessage = '',
  });

  CartState copyWith({
    List<CartItemEntity>? cartItems,
    double? totalPrice,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      totalPrice: totalPrice ?? this.totalPrice,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [cartItems, totalPrice, isLoading, errorMessage];
}
