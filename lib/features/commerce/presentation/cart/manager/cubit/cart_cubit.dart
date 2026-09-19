import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/use_case/add_cart_item_use_case.dart';
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

  CartCubit({
    required this.updateCartItemUseCase,
    required this.removeCartItemUseCase,
    required this.getCartUseCase,
    required this.addCartItemUseCase,
  }) : super(const CartState());

  void doEvent(CartEvent event) {
    switch (event) {
      case AddToCartEvent():
        _addCartItem(event.productId, event.quantity);
        break;

      case UpdateCartItemEvent():
        _updateCartItem(event.cartItemId, event.quantity);
        break;

      case RemoveCartItemEvent():
        _removeCartItem(event.cartItemId);
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
            loadingProductIds: const {},
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

  Future<void> _addCartItem(int productId, int quantity) async {
    if (state.loadingProductIds.contains(productId)) return;

    if (state.cart.items.any((item) => item.productId == productId)) return;

    emit(
      state.copyWith(
        loadingProductIds: {...state.loadingProductIds, productId},
        errorMessage: '',
        addToCartSuccess: false,
      ),
    );

    final params = AddCartItemParams(productId: productId, quantity: quantity);

    final result = await addCartItemUseCase.call(params);

    final updatedLoadingProductIds = {...state.loadingProductIds}
      ..remove(productId);

    switch (result) {
      case SuccessResponce<CartEntity>():
        emit(
          state.copyWith(
            data: result.data,
            loadingProductIds: updatedLoadingProductIds,
            errorMessage: '',
            addToCartSuccess: true,
          ),
        );
        break;

      case ErrorResponce<CartEntity>():
        emit(state.copyWith(loadingProductIds: updatedLoadingProductIds));
        break;
    }
  }

  Future<void> _updateCartItem(String cartItemId, int quantity) async {
    final productId = _productIdOf(cartItemId);

    if (productId != null) {
      if (state.loadingProductIds.contains(productId)) return;

      emit(
        state.copyWith(
          loadingProductIds: {...state.loadingProductIds, productId},
          errorMessage: '',
        ),
      );
    }

    final params = UpdateCartItemParams(quantity: quantity);

    final result = await updateCartItemUseCase.call(cartItemId, params);

    final updatedLoadingProductIds = productId == null
        ? state.loadingProductIds
        : ({...state.loadingProductIds}..remove(productId));

    switch (result) {
      case SuccessResponce<CartEntity>():
        emit(
          state.copyWith(
            data: result.data,
            loadingProductIds: updatedLoadingProductIds,
            errorMessage: '',
          ),
        );
        break;

      case ErrorResponce<CartEntity>():
        emit(state.copyWith(loadingProductIds: updatedLoadingProductIds));
        break;
    }
  }

  Future<void> _removeCartItem(String cartItemId) async {
    final productId = _productIdOf(cartItemId);

    if (productId != null) {
      if (state.loadingProductIds.contains(productId)) return;

      emit(
        state.copyWith(
          loadingProductIds: {...state.loadingProductIds, productId},
          errorMessage: '',
        ),
      );
    }

    final result = await removeCartItemUseCase.call(cartItemId);

    final updatedLoadingProductIds = productId == null
        ? state.loadingProductIds
        : ({...state.loadingProductIds}..remove(productId));

    switch (result) {
      case SuccessResponce<CartEntity>():
        emit(
          state.copyWith(
            data: result.data,
            loadingProductIds: updatedLoadingProductIds,
            errorMessage: '',
          ),
        );
        break;

      case ErrorResponce<CartEntity>():
        emit(state.copyWith(loadingProductIds: updatedLoadingProductIds));
        break;
    }
  }

  int? _productIdOf(String cartItemId) {
    for (final item in state.cart.items) {
      if (item.id == cartItemId) return item.productId;
    }
    return null;
  }
}
