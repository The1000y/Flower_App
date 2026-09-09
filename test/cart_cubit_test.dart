import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_item_entity.dart';
import 'package:flower_app/features/commerce/domain/use_case/add_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_cart_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/remove_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/update_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCartUseCase extends Mock implements GetCartUseCase {}

class MockAddCartItemUseCase extends Mock implements AddCartItemUseCase {}

class MockUpdateCartItemUseCase extends Mock implements UpdateCartItemUseCase {}

class MockRemoveCartItemUseCase extends Mock implements RemoveCartItemUseCase {}

void main() {
  late MockGetCartUseCase getCartUseCase;
  late MockAddCartItemUseCase addCartItemUseCase;
  late MockUpdateCartItemUseCase updateCartItemUseCase;
  late MockRemoveCartItemUseCase removeCartItemUseCase;
  late CartCubit cubit;

  setUp(() {
    getCartUseCase = MockGetCartUseCase();
    addCartItemUseCase = MockAddCartItemUseCase();
    updateCartItemUseCase = MockUpdateCartItemUseCase();
    removeCartItemUseCase = MockRemoveCartItemUseCase();

    cubit = CartCubit(
      getCartUseCase: getCartUseCase,
      addCartItemUseCase: addCartItemUseCase,
      updateCartItemUseCase: updateCartItemUseCase,
      removeCartItemUseCase: removeCartItemUseCase,
    );

    when(() => getCartUseCase.call()).thenAnswer(
      (_) async => SuccessResponce(
        CartEntity(
          items: [
            CartItemEntity(
              id: 'item-1',
              productId: 1,
              productName: 'Rose Bouquet',
              productImageUrl: 'https://example.com/rose.jpg',
              unitPrice: 200,
              quantity: 2,
              lineSubtotal: 400,
              inStock: true,
              priceChanged: false,
            ),
          ],
          subtotal: 400,
          deliveryFee: 20,
          total: 420,
          hasChanges: false,
        ),
      ),
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test('loads cart items when GetCartItemsEvent is dispatched', () async {
    cubit.doEvent(GetCartItemsEvent());

    await pumpEventQueue();

    expect(cubit.state.data?.items.length, 1);
    expect(cubit.state.data?.total, 420);
  });
}
