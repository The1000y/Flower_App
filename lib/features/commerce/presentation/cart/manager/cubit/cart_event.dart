sealed class CartEvent {}

class GetCartItemsEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final String productId;
  final int quantity;

  AddToCartEvent({required this.productId, required this.quantity});
}

class UpdateCartItemEvent extends CartEvent {
  final String cartItemId;

  /// The catalogue product id, because the backend PATCH route is keyed by it.
  final String productId;
  final int quantity;

  UpdateCartItemEvent({
    required this.cartItemId,
    required this.productId,
    required this.quantity,
  });
}

class RemoveCartItemEvent extends CartEvent {
  final String cartItemId;

  RemoveCartItemEvent({required this.cartItemId});
}

class ClearCartEvent extends CartEvent {}

class CartRefreshRequestedEvent extends CartEvent {}
