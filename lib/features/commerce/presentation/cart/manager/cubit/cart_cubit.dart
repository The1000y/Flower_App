import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/model/request/cart_request/add_cart_item_request_dto.dart';
import 'package:flower_app/features/commerce/data/model/request/cart_request/update_cart_item_request_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/use_case/add_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_cart_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/remove_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/update_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
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
    }
  }

  Future<void> _getCart() async {
  print('GET CART STARTED');

  emit(state.copyWith(
    isLoading: true,
    errorMessage: '',
  ));

  final result = await getCartUseCase.call();

  print('GET CART RESULT: $result');

  switch (result) {
    case SuccessResponce<CartEntity>():
      print('GET CART SUCCESS');
      print('CART ITEMS: ${result.data.items.length}');

      for (final item in result.data.items) {
        print(
          'ITEM: ${item.productName} | '
          'ID: ${item.productId} | '
          'QTY: ${item.quantity}',
        );
      }

      emit(
        state.copyWith(
          isLoading: false,
          cartItems: result.data.items,
          totalPrice: result.data.total,
          errorMessage: '',
        ),
      );
      break;

    case ErrorResponce<CartEntity>():
      print('GET CART ERROR: ${result.errorMessage}');

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: result.errorMessage,
        ),
      );
      break;
  }
}

 Future<void> _addCartItem(int productId, int quantity) async {
  print('🔥 ADD CART CLICKED: $productId - $quantity');

  emit(state.copyWith(
    isLoading: true,
    errorMessage: '',
  ));

  final request = AddCartItemRequestDto(
    productId: productId,
    quantity: quantity,
  );

  final result = await addCartItemUseCase.call(request);


  switch (result) {
    case SuccessResponce<CartEntity>():

      emit(
        state.copyWith(
          isLoading: false,
          cartItems: result.data.items,
          totalPrice: result.data.total,
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
  emit(state.copyWith(
    isLoading: true,
    errorMessage: '',
  ));

  final request = UpdateCartItemRequestDto(
    quantity: quantity,
  );

  final result = await updateCartItemUseCase.call(
    cartItemId,
    request,
  );

  switch (result) {
    case SuccessResponce<CartEntity>():
      emit(state.copyWith(
        isLoading: false,
        cartItems: result.data.items,
        totalPrice: result.data.total,
        errorMessage: '',
      ));
      break;

    case ErrorResponce<CartEntity>():
      emit(state.copyWith(
        isLoading: false,
        errorMessage: result.errorMessage,
      ));
      break;
  }
}
  Future<void> _removeCartItem(String cartItemId) async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));

    final result = await removeCartItemUseCase.call(cartItemId);

    switch (result) {
      case SuccessResponce<CartEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            cartItems: result.data.items,
            totalPrice: result.data.total,
            errorMessage: '',
          ),
        );
        break;
      case ErrorResponce<CartEntity>():
        emit(
          state.copyWith(isLoading: false, errorMessage: result.errorMessage),
        );
        break;
    }
  }
}
