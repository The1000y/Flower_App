import 'dart:async';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/use_case/add_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/clear_cart_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_cart_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/remove_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/update_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_state.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_ui_event.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/models/cart/add_cart_item_params.dart';
import '../../../../domain/models/cart/update_cart_item_params.dart';

/// Owns every business rule of the Cart feature.
///
/// The widget layer only renders [CartState] and forwards [CartEvent]s here.
/// Each operation writes to its own, isolated part of the state so one pending
/// call never blocks or rebuilds another.
@lazySingleton
class CartCubit extends Cubit<CartState> {
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveCartItemUseCase removeCartItemUseCase;
  final GetCartUseCase getCartUseCase;
  final AddCartItemUseCase addCartItemUseCase;
  final ClearCartUseCase clearCartUseCase;

  /// How long the user must stop tapping +/- before a quantity change is sent.
  /// Exposed so tests can shorten it.
  final Duration quantityDebounce;

  /// One timer per product id. Keeping a timer per product means several
  /// products can be waiting to be sent at the same time without their
  /// debounce windows interfering with each other.
  final Map<String, Timer> _quantityTimers = {};

  /// One-shot events for the presentation layer, exposed as [uiEvents]. A
  /// broadcast controller is used because several widgets can listen at once
  /// and none of them should own the stream.
  final StreamController<CartUiEvent> _uiEventsController =
      StreamController<CartUiEvent>.broadcast();

  /// Transient UI events (feedback for the widget layer). They are not part of
  /// [CartState] so they never replay on rebuild.
  Stream<CartUiEvent> get uiEvents => _uiEventsController.stream;

  CartCubit({
    required this.updateCartItemUseCase,
    required this.removeCartItemUseCase,
    required this.getCartUseCase,
    required this.addCartItemUseCase,
    required this.clearCartUseCase,
    this.quantityDebounce = const Duration(milliseconds: 700),
  }) : super(const CartState());

  Future<void> doEvent(CartEvent event) async {
    switch (event) {
      case AddToCartEvent():
        _addCartItem(event.productId, event.quantity);
      case UpdateCartItemEvent():
        _queueQuantityUpdate(
          cartItemId: event.cartItemId,
          productId: event.productId,
          quantity: event.quantity,
        );
      case RemoveCartItemEvent():
        _removeCartItem(event.cartItemId);
      case ClearCartEvent():
        await _clearCart();
      case GetCartItemsEvent() || CartRefreshRequestedEvent():
        _fetchCart();
      case ResetCartStateEvent():
        await _resetCartState();
    }
  }

  @override
  Future<void> close() {
    _cancelPendingQuantityUpdates();
    _uiEventsController.close();
    return super.close();
  }

  /// Emits [nextState] only while the cubit is still open.
  ///
  /// A request can finish after the cubit was closed (the cart is a long-lived
  /// singleton, so its owner can be gone by the time the response arrives).
  /// Emitting then would throw "Cannot emit new states after calling close", so
  /// the lifecycle is checked here instead of being swallowed by a `try/catch`
  /// at every call site.
  void _emitState(CartState nextState) {
    if (isClosed) return;
    emit(nextState);
  }

  /// Pushes a transient [CartUiEvent] to the presentation layer, unless the
  /// cubit has already been closed.
  void _emitUiEvent(CartUiEvent event) {
    if (_uiEventsController.isClosed) return;
    _uiEventsController.add(event);
  }

  // --------------------------------------------------------------- cart read

  /// Reads the whole cart.
  ///
  /// When [silent] is true the read is invisible: no loading flag is raised and
  /// a failure leaves the cart that is already on screen untouched. It is used
  /// to reconcile the server state after a mutation.
  Future<void> _fetchCart({bool silent = false}) async {
    if (!silent) {
      _cancelPendingQuantityUpdates();
      _emitState(
        state.copyWith(
          fetch: const RequestLoading<CartEntity>(),
          pendingQuantities: const {},
        ),
      );
    }

    final result = await getCartUseCase.call();

    switch (result) {
      case SuccessResponce<CartEntity>(:final data):
        _emitState(
          state.copyWith(
            data: data,
            fetch: RequestSuccess(data),
            clear: const RequestIdle<CartEntity>(),
            addingProductIds: const {},
            updatingProductIds: const {},
            removingCartItemIds: const {},
            pendingQuantities: const {},
          ),
        );
      case ErrorResponce<CartEntity>(:final errorMessage):
        // A silent refresh must never replace the cart with an error screen.
        if (silent) return;
        _emitState(state.copyWith(fetch: RequestFailure(errorMessage)));
    }
  }

  // -------------------------------------------------------------- add / remove

  Future<void> _addCartItem(String productId, int quantity) async {
    // Ignore a repeated tap while the same product is already being added, and
    // never add a product that is already in the cart.
    if (state.addingProductIds.contains(productId)) return;
    if (state.cart.items.any((item) => item.productId == productId)) return;

    _emitState(
      state.copyWith(addingProductIds: {...state.addingProductIds, productId}),
    );

    final result = await addCartItemUseCase.call(
      AddCartItemParams(productId: productId, quantity: quantity),
    );

    final addingProductIds = {...state.addingProductIds}..remove(productId);

    switch (result) {
      case SuccessResponce<CartEntity>(:final data):
        _emitState(
          state.copyWith(data: data, addingProductIds: addingProductIds),
        );
        _emitUiEvent(const AddToCartSuccessUiEvent());
      case ErrorResponce<CartEntity>(:final errorMessage):
        // The card/button stops spinning and the failure is surfaced as a
        // one-shot UI event instead of replacing the whole cart.
        _emitState(state.copyWith(addingProductIds: addingProductIds));
        _emitUiEvent(AddToCartFailureUiEvent(message: errorMessage));
    }
  }

  Future<void> _removeCartItem(String cartItemId) async {
    if (state.removingCartItemIds.contains(cartItemId)) return;

    _emitState(
      state.copyWith(
        removingCartItemIds: {...state.removingCartItemIds, cartItemId},
      ),
    );

    final result = await removeCartItemUseCase.call(cartItemId);

    final removingCartItemIds = {...state.removingCartItemIds}
      ..remove(cartItemId);

    switch (result) {
      case SuccessResponce<CartEntity>(:final data):
        _emitState(
          state.copyWith(data: data, removingCartItemIds: removingCartItemIds),
        );
      case ErrorResponce<CartEntity>():
        _emitState(state.copyWith(removingCartItemIds: removingCartItemIds));
    }
  }

  // -------------------------------------------------------------- quantities

  /// Applies the quantity change optimistically and (re)starts the product's
  /// debounce timer. The network call only happens once the user has stopped
  /// tapping for [quantityDebounce].
  ///
  /// A quantity of zero or less means "remove this line", which is done right
  /// away instead of being debounced.
  void _queueQuantityUpdate({
    required String cartItemId,
    required String productId,
    required int quantity,
  }) {
    if (quantity <= 0) {
      _quantityTimers.remove(productId)?.cancel();
      _emitState(
        state.copyWith(
          pendingQuantities: {...state.pendingQuantities}..remove(productId),
        ),
      );
      _removeCartItem(cartItemId);
      return;
    }

    _emitState(
      state.copyWith(
        pendingQuantities: {...state.pendingQuantities, productId: quantity},
      ),
    );

    _quantityTimers.remove(productId)?.cancel();
    _quantityTimers[productId] = Timer(
      quantityDebounce,
      () => _sendQuantityUpdate(productId),
    );
  }

  /// Sends the latest pending quantity for a product, then reconciles the
  /// response with the server.
  Future<void> _sendQuantityUpdate(String productId) async {
    _quantityTimers.remove(productId);

    final quantity = state.pendingQuantities[productId];
    if (quantity == null) return;

    // A request for this product is already running (the controls are hidden
    // behind a spinner while it is). Drop the duplicate instead of firing a
    // competing call; the running request reconciles the final value.
    if (state.updatingProductIds.contains(productId)) return;

    _emitState(
      state.copyWith(
        updatingProductIds: {...state.updatingProductIds, productId},
      ),
    );

    final result = await updateCartItemUseCase.call(
      productId,
      UpdateCartItemParams(quantity: quantity),
    );

    // The quantity route answers with a reduced line that omits the product
    // name, image and stock, so its payload cannot replace the rendered cart.
    // A successful update is therefore followed by an invisible cart read.
    if (result is SuccessResponce<CartEntity>) {
      await _refreshCartSilently();
    }

    _emitState(
      state.copyWith(
        updatingProductIds: {...state.updatingProductIds}..remove(productId),
        // Confirmed by the server, or rolled back to the last server value on
        // failure - either way the optimistic override is no longer needed.
        pendingQuantities: {...state.pendingQuantities}..remove(productId),
      ),
    );
  }

  /// Re-reads the cart without raising the whole-cart loading flag, so a
  /// quantity change never flashes a full-screen spinner. On failure the cart
  /// already on screen is kept untouched.
  Future<void> _refreshCartSilently() async {
    final result = await getCartUseCase.call();

    if (result case SuccessResponce<CartEntity>(:final data)) {
      _emitState(state.copyWith(data: data, fetch: RequestSuccess(data)));
    }
  }

  // ------------------------------------------------------------------- clear

  Future<void> _clearCart() async {
    if (state.clear.isLoading) return;

    _emitState(state.copyWith(clear: const RequestLoading<CartEntity>()));

    final result = await clearCartUseCase.call();

    switch (result) {
      case SuccessResponce<CartEntity>(:final data):
        _emitState(state.copyWith(data: data, clear: RequestSuccess(data)));
      case ErrorResponce<CartEntity>(:final errorMessage):
        _emitState(state.copyWith(clear: RequestFailure(errorMessage)));
    }
  }

  void _cancelPendingQuantityUpdates() {
    for (final timer in _quantityTimers.values) {
      timer.cancel();
    }
    _quantityTimers.clear();
  }

  Future<void> _resetCartState() async {
    return _emitState(const CartState());
  }
}
