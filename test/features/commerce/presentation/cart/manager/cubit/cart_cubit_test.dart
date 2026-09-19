import 'dart:async';

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
        isA<CartState>()
            .having(
              (state) => state.loadingProductIds,
              'loadingProductIds',
              contains(7),
            )
            .having((state) => state.isLoading, 'loading', false),
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
        isA<CartState>()
            .having(
              (state) => state.loadingProductIds,
              'loadingProductIds',
              contains(1),
            )
            .having((state) => state.isLoading, 'loading', false),
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
        isA<CartState>()
            .having(
              (state) => state.loadingProductIds,
              'loadingProductIds',
              contains(1),
            )
            .having((state) => state.isLoading, 'loading', false),
        isA<CartState>().having((state) => state.data, 'data', same(cart)),
      ]),
    );
    cubit.doEvent(RemoveCartItemEvent(cartItemId: 'item-1'));

    await emitted;
    verify(() => removeCartItemUseCase.call('item-1')).called(1);
  });

  test(
    'stops loading for the product and keeps the cart intact when an update fails',
    () async {
      when(() => updateCartItemUseCase.call(any(), any())).thenAnswer(
        (_) async => ErrorResponce<CartEntity>(Exception('update failed')),
      );

      final emitted = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<CartState>()
              .having(
                (state) => state.loadingProductIds,
                'loadingProductIds',
                contains(1),
              )
              .having((state) => state.isLoading, 'loading', false),
          isA<CartState>()
              .having(
                (state) => state.loadingProductIds,
                'loadingProductIds',
                isNot(contains(1)),
              )
              .having((state) => state.errorMessage, 'error', isEmpty),
        ]),
      );
      cubit.doEvent(UpdateCartItemEvent(cartItemId: 'item-1', quantity: 0));

      await emitted;
    },
  );

  test(
    'stops loading for the product and keeps the cart intact when a remove fails',
    () async {
      when(() => removeCartItemUseCase.call(any())).thenAnswer(
        (_) async => ErrorResponce<CartEntity>(Exception('remove failed')),
      );

      final emitted = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<CartState>()
              .having(
                (state) => state.loadingProductIds,
                'loadingProductIds',
                contains(1),
              )
              .having((state) => state.isLoading, 'loading', false),
          isA<CartState>()
              .having(
                (state) => state.loadingProductIds,
                'loadingProductIds',
                isNot(contains(1)),
              )
              .having((state) => state.errorMessage, 'error', isEmpty),
        ]),
      );
      cubit.doEvent(RemoveCartItemEvent(cartItemId: 'item-1'));

      await emitted;
    },
  );

  CartItemEntity item(int productId, String id) {
    return CartItemEntity(
      id: id,
      productId: productId,
      productName: 'Bouquet $productId',
      productImageUrl: 'https://example.com/$productId.jpg',
      unitPrice: 100,
      quantity: 1,
      lineSubtotal: 100,
      inStock: true,
      priceChanged: false,
    );
  }

  CartEntity cartWithItems(List<CartItemEntity> items) {
    return CartEntity(
      items: items,
      subtotal: 100,
      deliveryFee: 20,
      total: 120,
      hasChanges: false,
    );
  }

  Future<void> seedCart(CartEntity seededCart) async {
    when(
      () => getCartUseCase.call(),
    ).thenAnswer((_) async => SuccessResponce(seededCart));
    cubit.doEvent(GetCartItemsEvent());
    await pumpEventQueue();
  }

  test('loading is tracked independently per product for updates', () async {
    await seedCart(cartWithItems([item(1, 'item-1'), item(2, 'item-2')]));
    when(() => updateCartItemUseCase.call(any(), any())).thenAnswer(
      (_) async => SuccessResponce(
        cartWithItems([item(1, 'item-1'), item(2, 'item-2')]),
      ),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>()
            .having(
              (state) => state.loadingProductIds,
              'loadingProductIds',
              equals({1}),
            )
            .having(
              (state) => state.loadingProductIds,
              'product 2 not loading',
              isNot(contains(2)),
            )
            .having((state) => state.isLoading, 'loading', false),
        isA<CartState>().having(
          (state) => state.loadingProductIds,
          'loadingProductIds',
          isEmpty,
        ),
      ]),
    );

    cubit.doEvent(UpdateCartItemEvent(cartItemId: 'item-1', quantity: 2));

    await emitted;
  });

  test('loading is tracked independently per product for removals', () async {
    await seedCart(cartWithItems([item(1, 'item-1'), item(2, 'item-2')]));
    when(() => removeCartItemUseCase.call(any())).thenAnswer(
      (_) async => SuccessResponce(cartWithItems([item(2, 'item-2')])),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>()
            .having(
              (state) => state.loadingProductIds,
              'loadingProductIds',
              equals({1}),
            )
            .having(
              (state) => state.loadingProductIds,
              'product 2 not loading',
              isNot(contains(2)),
            ),
        isA<CartState>().having(
          (state) => state.loadingProductIds,
          'loadingProductIds',
          isEmpty,
        ),
      ]),
    );

    cubit.doEvent(RemoveCartItemEvent(cartItemId: 'item-1'));

    await emitted;
  });

  test('does not add a product that is already in the cart', () async {
    await seedCart(cartWithItems([item(7, 'item-7')]));

    cubit.doEvent(AddToCartEvent(productId: 7, quantity: 1));
    await pumpEventQueue();

    verifyNever(() => addCartItemUseCase.call(any()));
  });

  test(
    'still adds another product when one product is already in the cart',
    () async {
      await seedCart(cartWithItems([item(7, 'item-7')]));
      when(() => addCartItemUseCase.call(any())).thenAnswer(
        (_) async => SuccessResponce(
          cartWithItems([item(7, 'item-7'), item(9, 'item-9')]),
        ),
      );

      final emitted = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<CartState>().having(
            (state) => state.loadingProductIds,
            'loadingProductIds',
            contains(9),
          ),
          isA<CartState>().having(
            (state) => state.addToCartSuccess,
            'success',
            true,
          ),
        ]),
      );

      cubit.doEvent(AddToCartEvent(productId: 9, quantity: 1));

      await emitted;
    },
  );

  test(
    'does not dispatch duplicate requests for the same product while it is loading',
    () async {
      await seedCart(cartWithItems([item(1, 'item-1'), item(2, 'item-2')]));

      final completer = Completer<BaseResponce<CartEntity>>();
      when(
        () => updateCartItemUseCase.call(any(), any()),
      ).thenAnswer((_) => completer.future);

      cubit.doEvent(UpdateCartItemEvent(cartItemId: 'item-1', quantity: 2));
      await pumpEventQueue();

      // A second update and an add for the same product are dropped while loading.
      cubit.doEvent(UpdateCartItemEvent(cartItemId: 'item-1', quantity: 3));
      cubit.doEvent(AddToCartEvent(productId: 1, quantity: 1));
      await pumpEventQueue();

      expect(cubit.state.loadingProductIds, equals({1}));
      verify(() => updateCartItemUseCase.call(any(), any())).called(1);
      verifyNever(() => addCartItemUseCase.call(any()));

      completer.complete(
        SuccessResponce(cartWithItems([item(1, 'item-1'), item(2, 'item-2')])),
      );
      await pumpEventQueue();

      expect(cubit.state.loadingProductIds, isEmpty);
    },
  );

  test('a failed update stops loading only for that product', () async {
    await seedCart(cartWithItems([item(1, 'item-1'), item(2, 'item-2')]));
    when(() => updateCartItemUseCase.call(any(), any())).thenAnswer(
      (_) async => ErrorResponce<CartEntity>(Exception('update failed')),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having(
          (state) => state.loadingProductIds,
          'loadingProductIds',
          equals({1}),
        ),
        isA<CartState>()
            .having(
              (state) => state.loadingProductIds,
              'loadingProductIds',
              isEmpty,
            )
            .having((state) => state.errorMessage, 'error', isEmpty)
            .having((state) => state.data, 'cart unchanged', isNotNull),
      ]),
    );

    cubit.doEvent(UpdateCartItemEvent(cartItemId: 'item-1', quantity: 2));

    await emitted;
  });
}
