import 'package:equatable/equatable.dart';

import '../../../../domain/entities/cart/cart_entity.dart';
import 'request_state.dart';

/// The immutable snapshot the Cart screen renders from.
///
/// Every asynchronous operation owns an isolated slice of this state instead of
/// sharing a handful of booleans:
///
/// * [fetch] - the whole-cart read (first load, retry and tab refresh).
/// * [clear] - the whole-cart clear.
/// * [addingProductIds], [updatingProductIds], [removingCartItemIds] - the
///   per-item mutations, tracked independently so loading one item never
///   affects another.
/// * [pendingQuantities] - optimistic quantities the user picked but the server
///   has not confirmed yet.
///
/// Because the operations are separated, the UI can read exactly the slice it
/// needs (see the selectors in the widgets) and never rebuilds more than it has
/// to.
class CartState extends Equatable {
  /// The cart currently rendered; `null` until the first successful read.
  final CartEntity? data;

  /// Lifecycle of the whole-cart read.
  final RequestState<CartEntity> fetch;

  /// Lifecycle of the whole-cart clear.
  final RequestState<CartEntity> clear;

  /// Product ids with an in-flight "add to cart" request.
  final Set<String> addingProductIds;

  /// Product ids with an in-flight "change quantity" request.
  final Set<String> updatingProductIds;

  /// Cart line ids with an in-flight "remove" request.
  final Set<String> removingCartItemIds;

  /// Locally applied quantities the server has not confirmed yet, keyed by
  /// product id. The optimistic value is kept here rather than written into
  /// [data] so the immutable domain entity is never mutated.
  final Map<String, int> pendingQuantities;

  const CartState({
    this.data,
    this.fetch = const RequestIdle<CartEntity>(),
    this.clear = const RequestIdle<CartEntity>(),
    this.addingProductIds = const {},
    this.updatingProductIds = const {},
    this.removingCartItemIds = const {},
    this.pendingQuantities = const {},
  });

  /// The cart to render, falling back to an empty one before the first load.
  CartEntity get cart =>
      data ??
      CartEntity(items: const [], subtotal: 0, total: 0, hasChanges: false);

  /// The whole-screen error message, or `''` when there is none.
  ///
  /// Only the cart-wide operations surface an error this way. Per-item failures
  /// stay silent so they never replace the cart with an error page.
  String get errorMessage {
    if (fetch case RequestFailure<CartEntity>(:final message)) return message;
    return '';
  }

  /// True while the whole cart is being read.
  bool get isFetching => fetch.isLoading;

  /// True while the cart is being cleared.
  bool get isClearingCart => clear.isLoading;

  /// True while an add-to-cart request is running for [productId].
  bool isProductLoading(String productId) =>
      addingProductIds.contains(productId);

  /// True while a quantity change is running for [productId].
  bool isProductUpdating(String productId) =>
      updatingProductIds.contains(productId);

  /// True while a remove is running for [cartItemId].
  bool isCartItemRemoving(String cartItemId) =>
      removingCartItemIds.contains(cartItemId);

  /// True while any mutation is running for [productId].
  bool isItemBusy(String productId) =>
      isProductLoading(productId) || isProductUpdating(productId);

  /// The quantity to display for a product: the optimistic value while it is
  /// pending, otherwise the value the server last reported.
  int displayQuantity(String productId, int serverQuantity) =>
      pendingQuantities[productId] ?? serverQuantity;

  CartState copyWith({
    CartEntity? data,
    RequestState<CartEntity>? fetch,
    RequestState<CartEntity>? clear,
    Set<String>? addingProductIds,
    Set<String>? updatingProductIds,
    Set<String>? removingCartItemIds,
    Map<String, int>? pendingQuantities,
  }) {
    return CartState(
      data: data ?? this.data,
      fetch: fetch ?? this.fetch,
      clear: clear ?? this.clear,
      addingProductIds: addingProductIds ?? this.addingProductIds,
      updatingProductIds: updatingProductIds ?? this.updatingProductIds,
      removingCartItemIds: removingCartItemIds ?? this.removingCartItemIds,
      pendingQuantities: pendingQuantities ?? this.pendingQuantities,
    );
  }

  @override
  List<Object?> get props => [
    data,
    fetch,
    clear,
    addingProductIds,
    updatingProductIds,
    removingCartItemIds,
    pendingQuantities,
  ];
}
