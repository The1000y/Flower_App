import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/use_case/add_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/clear_cart_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_cart_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/remove_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/update_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/models/cart/add_cart_item_params.dart';
import '../../../../domain/models/cart/update_cart_item_params.dart';

@lazySingleton
class CartCubit extends Cubit<CartState> {
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveCartItemUseCase removeCartItemUseCase;
  final GetCartUseCase getCartUseCase;
  final AddCartItemUseCase addCartItemUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartCubit({
    required this.updateCartItemUseCase,
    required this.removeCartItemUseCase,
    required this.getCartUseCase,
    required this.addCartItemUseCase,
    required this.clearCartUseCase,
  }) : super(const CartState());

  void doEvent(CartEvent event) {
    switch (event) {
      case AddToCartEvent():
        _addCartItem(event.productId, event.quantity);
        break;

      case UpdateCartItemEvent():
        _updateCartItem(event.productId, event.quantity);
        break;

      case RemoveCartItemEvent():
        _removeCartItem(event.cartItemId);
        break;

      case ClearCartEvent():
        _clearCart();
        break;

      case GetCartItemsEvent():
        _getCart();
        break;

      case CartRefreshRequestedEvent():
        _getCart();
        break;
    }
  }

  Future<void> _getCart() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: '',
        addToCartSuccess: false,
      ),
    );

    final result = await getCartUseCase.call();

    switch (result) {
      case SuccessResponce<CartEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            data: result.data,
            errorMessage: '',
            addToCartSuccess: false,
            itemLoadings: const {},
          ),
        );
        break;

      case ErrorResponce<CartEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.errorMessage,
            addToCartSuccess: false,
          ),
        );
        break;
    }
  }

  Future<void> _addCartItem(String productId, int quantity) async {
    final loading = CartItemLoading(id: productId, action: CartItemAction.add);
    if (state.itemLoadings.contains(loading)) return;

    if (state.cart.items.any((item) => item.productId == productId)) return;

    emit(
      state.copyWith(
        itemLoadings: {...state.itemLoadings, loading},
        errorMessage: '',
        addToCartSuccess: false,
      ),
    );

    final params = AddCartItemParams(productId: productId, quantity: quantity);

    final result = await addCartItemUseCase.call(params);

    final updatedLoadings = {...state.itemLoadings}..remove(loading);

    switch (result) {
      case SuccessResponce<CartEntity>():
        emit(
          state.copyWith(
            data: result.data,
            itemLoadings: updatedLoadings,
            errorMessage: '',
            addToCartSuccess: true,
          ),
        );
        break;

      case ErrorResponce<CartEntity>():
        // Item-level failures deliberately leave the rendered cart in place:
        // the error view replaces the whole screen, so it is reserved for the
        // cart-wide fetch and clear operations.
        emit(state.copyWith(itemLoadings: updatedLoadings));
        break;
    }
  }

  Future<void> _updateCartItem(String productId, int quantity) async {
    final loading = CartItemLoading(
      id: productId,
      action: CartItemAction.update,
    );
    if (state.itemLoadings.contains(loading)) return;

    emit(
      state.copyWith(
        itemLoadings: {...state.itemLoadings, loading},
        errorMessage: '',
      ),
    );

    final params = UpdateCartItemParams(quantity: quantity);

    final result = await updateCartItemUseCase.call(productId, params);

    final updatedLoadings = {...state.itemLoadings}..remove(loading);

    switch (result) {
      case SuccessResponce<CartEntity>():
        emit(
          state.copyWith(
            data: result.data,
            itemLoadings: updatedLoadings,
            errorMessage: '',
          ),
        );
        break;

      case ErrorResponce<CartEntity>():
        emit(state.copyWith(itemLoadings: updatedLoadings));
        break;
    }
  }

  Future<void> _removeCartItem(String cartItemId) async {
    final loading = CartItemLoading(
      id: cartItemId,
      action: CartItemAction.remove,
    );
    if (state.itemLoadings.contains(loading)) return;

    emit(
      state.copyWith(
        itemLoadings: {...state.itemLoadings, loading},
        errorMessage: '',
      ),
    );

    final result = await removeCartItemUseCase.call(cartItemId);

    final updatedLoadings = {...state.itemLoadings}..remove(loading);

    switch (result) {
      case SuccessResponce<CartEntity>():
        emit(
          state.copyWith(
            data: result.data,
            itemLoadings: updatedLoadings,
            errorMessage: '',
          ),
        );
        break;

      case ErrorResponce<CartEntity>():
        emit(state.copyWith(itemLoadings: updatedLoadings));
        break;
    }
  }

  Future<void> _clearCart() async {
    if (state.isClearingCart) return;

    emit(state.copyWith(isClearingCart: true, errorMessage: ''));

    final result = await clearCartUseCase.call();

    switch (result) {
      case SuccessResponce<CartEntity>():
        emit(
          state.copyWith(
            isClearingCart: false,
            data: result.data,
            errorMessage: '',
          ),
        );
        break;

      case ErrorResponce<CartEntity>():
        emit(
          state.copyWith(
            isClearingCart: false,
            errorMessage: result.errorMessage,
          ),
        );
        break;
    }
  }
}
