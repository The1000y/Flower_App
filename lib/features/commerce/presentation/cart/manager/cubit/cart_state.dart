import 'package:equatable/equatable.dart';

import '../../../../domain/entities/cart/cart_entity.dart';

enum CartItemAction { add, update, remove }

/// Identifies a single in-flight cart operation so that adding, updating and
/// removing are tracked independently per item.
class CartItemLoading extends Equatable {
  /// The catalogue product id for [CartItemAction.add] and
  /// [CartItemAction.update], the cart line id for [CartItemAction.remove].
  final String id;
  final CartItemAction action;

  const CartItemLoading({required this.id, required this.action});

  @override
  List<Object?> get props => [id, action];
}

class CartState extends Equatable {
  /// Whole-cart loading, used by the initial fetch only.
  final bool isLoading;

  /// Whole-cart loading for the clear-cart operation.
  final bool isClearingCart;

  final String errorMessage;
  final CartEntity? data;
  final bool addToCartSuccess;
  final Set<CartItemLoading> itemLoadings;

  const CartState({
    this.isLoading = false,
    this.isClearingCart = false,
    this.errorMessage = '',
    this.data,
    this.addToCartSuccess = false,
    this.itemLoadings = const {},
  });

  CartEntity get cart =>
      data ??
      CartEntity(items: const [], subtotal: 0, total: 0, hasChanges: false);

  bool isProductLoading(String productId) => itemLoadings.contains(
    CartItemLoading(id: productId, action: CartItemAction.add),
  );

  bool isItemUpdating(String productId) => itemLoadings.contains(
    CartItemLoading(id: productId, action: CartItemAction.update),
  );

  bool isItemRemoving(String cartItemId) => itemLoadings.contains(
    CartItemLoading(id: cartItemId, action: CartItemAction.remove),
  );

  /// True while any operation is pending for the given catalogue product.
  bool isItemBusy(String productId) => itemLoadings.any(
    (loading) =>
        loading.id == productId && loading.action != CartItemAction.remove,
  );

  CartState copyWith({
    bool? isLoading,
    bool? isClearingCart,
    String? errorMessage,
    CartEntity? data,
    bool? addToCartSuccess,
    Set<CartItemLoading>? itemLoadings,
  }) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      isClearingCart: isClearingCart ?? this.isClearingCart,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
      addToCartSuccess: addToCartSuccess ?? this.addToCartSuccess,
      itemLoadings: itemLoadings ?? this.itemLoadings,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isClearingCart,
    errorMessage,
    data,
    addToCartSuccess,
    itemLoadings,
  ];
}
