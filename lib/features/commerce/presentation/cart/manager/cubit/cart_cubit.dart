
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
          ),
        );
        break;

      case ErrorResponce<CartEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.errorMessage,
          ),
        );
        break;
    }
  }

  Future<void> _addCartItem(
    int productId,
    int quantity,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: '',
      ),
    );

    final params = AddCartItemParams(
      productId: productId,
      quantity: quantity,
    );

    final result = await addCartItemUseCase.call(params);

    switch (result) {
      case SuccessResponce<CartEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            data: result.data,
            errorMessage: '',
          ),
        );
        break;

      case ErrorResponce<CartEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.errorMessage,
          ),
        );
        break;
    }
  }

  Future<void> _updateCartItem(
    String cartItemId,
    int quantity,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: '',
      ),
    );

    final params = UpdateCartItemParams(
      quantity: quantity,
    );

    final result = await updateCartItemUseCase.call(
      cartItemId,
      params,
    );

    switch (result) {
      case SuccessResponce<CartEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            data: result.data,
            errorMessage: '',
          ),
        );
        break;

      case ErrorResponce<CartEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.errorMessage,
          ),
        );
        break;
    }
  }

  Future<void> _removeCartItem(String cartItemId) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: '',
      ),
    );

    final result = await removeCartItemUseCase.call(cartItemId);

    switch (result) {
      case SuccessResponce<CartEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            data: result.data,
            errorMessage: '',
          ),
        );
        break;

      case ErrorResponce<CartEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.errorMessage,
          ),
        );
        break;
    }
  }
}

