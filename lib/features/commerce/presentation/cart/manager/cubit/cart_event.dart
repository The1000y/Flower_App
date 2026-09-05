sealed class CartEvent {}

class GetCartItemsEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final int productId;
  final int quantity;

  AddToCartEvent({required this.productId, required this.quantity});
}

class UpdateCartItemEvent extends CartEvent {
  final String cartItemId;
  final int quantity;

  UpdateCartItemEvent({required this.cartItemId, required this.quantity});
}

class RemoveCartItemEvent extends CartEvent {
  final String cartItemId;

  RemoveCartItemEvent({required this.cartItemId});
}
