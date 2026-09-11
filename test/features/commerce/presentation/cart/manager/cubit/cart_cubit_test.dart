import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_item_entity.dart';
import 'package:flower_app/features/commerce/domain/models/cart/add_cart_item_params.dart';
import 'package:flower_app/features/commerce/domain/models/cart/update_cart_item_params.dart';
import 'package:flower_app/features/commerce/domain/use_case/add_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_cart_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/remove_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/update_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_state.dart';
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

  final cart = CartEntity(
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
  );

  setUpAll(() {
    registerFallbackValue(const AddCartItemParams(productId: 0, quantity: 0));
    registerFallbackValue(const UpdateCartItemParams(quantity: 0));
  });

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
  });

  tearDown(() => cubit.close());

  test('has an empty initial state', () {
    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.errorMessage, isEmpty);
    expect(cubit.state.data, isNull);
    expect(cubit.state.cart.items, isEmpty);
  });

  test('gets the cart and emits loading then success', () async {
    when(
      () => getCartUseCase.call(),
    ).thenAnswer((_) async => SuccessResponce(cart));

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having((state) => state.isLoading, 'loading', true),
        isA<CartState>()
            .having((state) => state.isLoading, 'loading', false)
            .having((state) => state.data, 'data', same(cart)),
      ]),
    );
    cubit.doEvent(GetCartItemsEvent());

    await emitted;
    verify(() => getCartUseCase.call()).called(1);
  });

  test('emits an error when getting the cart fails', () async {
    when(() => getCartUseCase.call()).thenAnswer(
      (_) async => ErrorResponce<CartEntity>(Exception('get failed')),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having((state) => state.isLoading, 'loading', true),
        isA<CartState>()
            .having((state) => state.isLoading, 'loading', false)
            .having((state) => state.errorMessage, 'error', isNotEmpty),
      ]),
    );
    cubit.doEvent(CartRefreshRequestedEvent());

    await emitted;
  });

  test('adds an item using event parameters', () async {
    when(
      () => addCartItemUseCase.call(any()),
    ).thenAnswer((_) async => SuccessResponce(cart));

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having((state) => state.isLoading, 'loading', true),
        isA<CartState>().having((state) => state.data, 'data', same(cart)),
      ]),
    );
    cubit.doEvent(AddToCartEvent(productId: 7, quantity: 3));

    await emitted;
    final params =
        verify(() => addCartItemUseCase.call(captureAny())).captured.single
            as AddCartItemParams;
    expect(params.productId, 7);
    expect(params.quantity, 3);
  });

  test('updates an item using event parameters', () async {
    when(
      () => updateCartItemUseCase.call(any(), any()),
    ).thenAnswer((_) async => SuccessResponce(cart));

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having((state) => state.isLoading, 'loading', true),
        isA<CartState>().having((state) => state.data, 'data', same(cart)),
      ]),
    );
    cubit.doEvent(UpdateCartItemEvent(cartItemId: 'item-1', quantity: 4));

    await emitted;
    final invocation = verify(
      () => updateCartItemUseCase.call('item-1', captureAny()),
    ).captured;
    expect((invocation.single as UpdateCartItemParams).quantity, 4);
  });

  test('removes an item using the event id', () async {
    when(
      () => removeCartItemUseCase.call(any()),
    ).thenAnswer((_) async => SuccessResponce(cart));

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having((state) => state.isLoading, 'loading', true),
        isA<CartState>().having((state) => state.data, 'data', same(cart)),
      ]),
    );
    cubit.doEvent(RemoveCartItemEvent(cartItemId: 'item-1'));

    await emitted;
    verify(() => removeCartItemUseCase.call('item-1')).called(1);
  });

  test('emits an error when an update fails', () async {
    when(() => updateCartItemUseCase.call(any(), any())).thenAnswer(
      (_) async => ErrorResponce<CartEntity>(Exception('update failed')),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having((state) => state.isLoading, 'loading', true),
        isA<CartState>()
            .having((state) => state.isLoading, 'loading', false)
            .having((state) => state.errorMessage, 'error', isNotEmpty),
      ]),
    );
    cubit.doEvent(UpdateCartItemEvent(cartItemId: 'item-1', quantity: 0));

    await emitted;
  });

  test('emits an error when a remove fails', () async {
    when(() => removeCartItemUseCase.call(any())).thenAnswer(
      (_) async => ErrorResponce<CartEntity>(Exception('remove failed')),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having((state) => state.isLoading, 'loading', true),
        isA<CartState>()
            .having((state) => state.isLoading, 'loading', false)
            .having((state) => state.errorMessage, 'error', isNotEmpty),
      ]),
    );
    cubit.doEvent(RemoveCartItemEvent(cartItemId: 'item-1'));

    await emitted;
  });
}
