import 'dart:async';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_item_entity.dart';
import 'package:flower_app/features/commerce/domain/models/cart/add_cart_item_params.dart';
import 'package:flower_app/features/commerce/domain/models/cart/update_cart_item_params.dart';
import 'package:flower_app/features/commerce/domain/use_case/add_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/clear_cart_use_case.dart';
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

class MockClearCartUseCase extends Mock implements ClearCartUseCase {}

CartItemLoading adding(String productId) =>
    CartItemLoading(id: productId, action: CartItemAction.add);

CartItemLoading updating(String productId) =>
    CartItemLoading(id: productId, action: CartItemAction.update);

CartItemLoading removing(String cartItemId) =>
    CartItemLoading(id: cartItemId, action: CartItemAction.remove);

void main() {
  late MockGetCartUseCase getCartUseCase;
  late MockAddCartItemUseCase addCartItemUseCase;
  late MockUpdateCartItemUseCase updateCartItemUseCase;
  late MockRemoveCartItemUseCase removeCartItemUseCase;
  late MockClearCartUseCase clearCartUseCase;
  late CartCubit cubit;

  final cart = CartEntity(
    items: [
      CartItemEntity(
        id: 'item-1',
        productId: '1',
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

  /// Stands in for the authoritative cart re-read after a quantity change,
  /// deliberately a different instance from the one the mutation answers with.
  final refreshedCart = CartEntity(
    items: [
      CartItemEntity(
        id: 'item-1',
        productId: '1',
        productName: 'Rose Bouquet',
        productImageUrl: 'https://example.com/rose.jpg',
        unitPrice: 200,
        quantity: 4,
        lineSubtotal: 800,
        inStock: true,
        priceChanged: false,
      ),
    ],
    subtotal: 800,
    deliveryFee: 20,
    total: 820,
    hasChanges: false,
  );

  setUpAll(() {
    registerFallbackValue(const AddCartItemParams(productId: '', quantity: 0));
    registerFallbackValue(const UpdateCartItemParams(quantity: 0));
  });

  setUp(() {
    getCartUseCase = MockGetCartUseCase();
    addCartItemUseCase = MockAddCartItemUseCase();
    updateCartItemUseCase = MockUpdateCartItemUseCase();
    removeCartItemUseCase = MockRemoveCartItemUseCase();
    clearCartUseCase = MockClearCartUseCase();
    cubit = CartCubit(
      getCartUseCase: getCartUseCase,
      addCartItemUseCase: addCartItemUseCase,
      updateCartItemUseCase: updateCartItemUseCase,
      removeCartItemUseCase: removeCartItemUseCase,
      clearCartUseCase: clearCartUseCase,
    );
    // A successful quantity change re-reads the cart, so the fetch is stubbed
    // by default and overridden by the tests that care about its outcome.
    when(
      () => getCartUseCase.call(),
    ).thenAnswer((_) async => SuccessResponce(cart));
  });

  tearDown(() => cubit.close());

  /// `doEvent` is fire-and-forget, so the emitted states are used to know when
  /// the item operation has settled.
  Future<void> runSettled(CartEvent event) async {
    final settled = expectLater(
      cubit.stream,
      emitsThrough(
        isA<CartState>().having(
          (state) => state.itemLoadings,
          'itemLoadings',
          isEmpty,
        ),
      ),
    );
    cubit.doEvent(event);
    await settled;
  }

  test('has an empty initial state', () {
    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.isClearingCart, isFalse);
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
            .having((state) => state.itemLoadings, 'itemLoadings', {
              adding('7'),
            })
            .having((state) => state.isLoading, 'loading', false),
        isA<CartState>().having((state) => state.data, 'data', same(cart)),
      ]),
    );
    cubit.doEvent(AddToCartEvent(productId: '7', quantity: 3));

    await emitted;
    final params =
        verify(() => addCartItemUseCase.call(captureAny())).captured.single
            as AddCartItemParams;
    expect(params.productId, '7');
    expect(params.quantity, 3);
  });

  test('an add marks only the add action as loading for that product', () async {
    final completer = Completer<BaseResponce<CartEntity>>();
    when(() => addCartItemUseCase.call(any())).thenAnswer(
      (_) => completer.future,
    );

    cubit.doEvent(AddToCartEvent(productId: '7', quantity: 1));
    await pumpEventQueue();

    expect(cubit.state.isProductLoading('7'), isTrue);
    expect(cubit.state.isItemUpdating('7'), isFalse);
    expect(cubit.state.isItemRemoving('7'), isFalse);

    completer.complete(SuccessResponce(cart));
    await pumpEventQueue();
  });

  test('updates an item using the product id and quantity', () async {
    when(
      () => updateCartItemUseCase.call(any(), any()),
    ).thenAnswer((_) async => SuccessResponce(cart));
    when(
      () => getCartUseCase.call(),
    ).thenAnswer((_) async => SuccessResponce(refreshedCart));

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having((state) => state.itemLoadings, 'itemLoadings', {
          updating('1'),
        }),
        isA<CartState>().having(
          (state) => state.data,
          'data',
          same(refreshedCart),
        ),
      ]),
    );
    cubit.doEvent(
      UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 4),
    );

    await emitted;
    final invocation = verify(
      () => updateCartItemUseCase.call('1', captureAny()),
    ).captured;
    expect((invocation.single as UpdateCartItemParams).quantity, 4);
  });

  test('re-reads the cart so the new quantity shows up immediately', () async {
    when(
      () => updateCartItemUseCase.call(any(), any()),
    ).thenAnswer((_) async => SuccessResponce(cart));
    when(
      () => getCartUseCase.call(),
    ).thenAnswer((_) async => SuccessResponce(refreshedCart));

    await runSettled(
      UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 4),
    );

    verify(() => getCartUseCase.call()).called(1);
    expect(cubit.state.data, same(refreshedCart));
    expect(cubit.state.data!.items.single.quantity, 4);
  });

  test('does not show a whole-cart spinner while re-reading', () async {
    when(
      () => updateCartItemUseCase.call(any(), any()),
    ).thenAnswer((_) async => SuccessResponce(cart));
    when(
      () => getCartUseCase.call(),
    ).thenAnswer((_) async => SuccessResponce(refreshedCart));

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having((state) => state.isLoading, 'loading', isFalse),
        isA<CartState>().having((state) => state.isLoading, 'loading', isFalse),
      ]),
    );
    cubit.doEvent(
      UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 4),
    );

    await emitted;
  });

  test('keeps the cart on screen when the re-read fails', () async {
    when(
      () => getCartUseCase.call(),
    ).thenAnswer((_) async => SuccessResponce(cart));
    when(
      () => updateCartItemUseCase.call(any(), any()),
    ).thenAnswer((_) async => SuccessResponce(cart));

    await runSettled(GetCartItemsEvent());
    final before = cubit.state.data;

    when(() => getCartUseCase.call()).thenAnswer(
      (_) async => ErrorResponce<CartEntity>(Exception('refetch failed')),
    );

    await runSettled(
      UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 4),
    );

    expect(cubit.state.data, same(before));
    expect(cubit.state.itemLoadings, isEmpty);
  });

  test('does not re-read the cart when the update itself fails', () async {
    when(() => updateCartItemUseCase.call(any(), any())).thenAnswer(
      (_) async => ErrorResponce<CartEntity>(Exception('update failed')),
    );

    await runSettled(
      UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 4),
    );

    verifyNever(() => getCartUseCase.call());
  });

  test('removes an item using the cart line id', () async {
    when(
      () => removeCartItemUseCase.call(any()),
    ).thenAnswer((_) async => SuccessResponce(cart));

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having((state) => state.itemLoadings, 'itemLoadings', {
          removing('item-1'),
        }),
        isA<CartState>().having((state) => state.data, 'data', same(cart)),
      ]),
    );
    cubit.doEvent(RemoveCartItemEvent(cartItemId: 'item-1'));

    await emitted;
    verify(() => removeCartItemUseCase.call('item-1')).called(1);
  });

  test('a remove marks only that cart line as loading', () async {
    final completer = Completer<BaseResponce<CartEntity>>();
    when(() => removeCartItemUseCase.call(any())).thenAnswer(
      (_) => completer.future,
    );

    cubit.doEvent(RemoveCartItemEvent(cartItemId: 'item-1'));
    await pumpEventQueue();

    expect(cubit.state.isItemRemoving('item-1'), isTrue);
    expect(cubit.state.isItemRemoving('item-2'), isFalse);
    expect(cubit.state.isProductLoading('item-1'), isFalse);

    completer.complete(SuccessResponce(cart));
    await pumpEventQueue();
  });

  test('an update and a remove of the same product run independently', () async {
    final updateCompleter = Completer<BaseResponce<CartEntity>>();
    when(() => updateCartItemUseCase.call(any(), any())).thenAnswer(
      (_) => updateCompleter.future,
    );
    when(() => removeCartItemUseCase.call(any())).thenAnswer(
      (_) async => SuccessResponce(cart),
    );

    cubit.doEvent(
      UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 2),
    );
    await pumpEventQueue();

    expect(cubit.state.isItemUpdating('1'), isTrue);
    expect(cubit.state.isItemRemoving('item-1'), isFalse);

    // A removal for the same product is not blocked by the pending update.
    cubit.doEvent(RemoveCartItemEvent(cartItemId: 'item-1'));
    await pumpEventQueue();

    verify(() => removeCartItemUseCase.call('item-1')).called(1);

    updateCompleter.complete(SuccessResponce(cart));
    await pumpEventQueue();
  });

  test('clears the cart and emits the cleared state', () async {
    final emptyCart = CartEntity(
      items: const [],
      subtotal: 0,
      total: 0,
      hasChanges: false,
    );
    when(() => clearCartUseCase.call()).thenAnswer(
      (_) async => SuccessResponce(emptyCart),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having(
          (state) => state.isClearingCart,
          'isClearingCart',
          true,
        ),
        isA<CartState>()
            .having((state) => state.isClearingCart, 'isClearingCart', false)
            .having((state) => state.data, 'data', same(emptyCart)),
      ]),
    );
    cubit.doEvent(ClearCartEvent());

    await emitted;
    verify(() => clearCartUseCase.call()).called(1);
  });

  test('clearCart does not blank the cart while it is pending', () async {
    final completer = Completer<BaseResponce<CartEntity>>();
    when(() => clearCartUseCase.call()).thenAnswer((_) => completer.future);

    cubit.doEvent(ClearCartEvent());
    await pumpEventQueue();

    expect(cubit.state.isClearingCart, isTrue);
    expect(cubit.state.isLoading, isFalse);

    completer.complete(
      SuccessResponce(
        CartEntity(items: const [], subtotal: 0, total: 0, hasChanges: false),
      ),
    );
    await pumpEventQueue();
  });

  test('does not dispatch duplicate clear requests while clearing', () async {
    final completer = Completer<BaseResponce<CartEntity>>();
    when(() => clearCartUseCase.call()).thenAnswer((_) => completer.future);

    cubit.doEvent(ClearCartEvent());
    await pumpEventQueue();
    cubit.doEvent(ClearCartEvent());
    await pumpEventQueue();

    verify(() => clearCartUseCase.call()).called(1);

    completer.complete(
      SuccessResponce(
        CartEntity(items: const [], subtotal: 0, total: 0, hasChanges: false),
      ),
    );
    await pumpEventQueue();
  });

  test('surfaces a clear failure and stops the clearing flag', () async {
    when(() => clearCartUseCase.call()).thenAnswer(
      (_) async => ErrorResponce<CartEntity>(Exception('clear failed')),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having(
          (state) => state.isClearingCart,
          'isClearingCart',
          true,
        ),
        isA<CartState>()
            .having((state) => state.isClearingCart, 'isClearingCart', false)
            .having((state) => state.errorMessage, 'error', isNotEmpty),
      ]),
    );
    cubit.doEvent(ClearCartEvent());

    await emitted;
  });

  test('stops loading and keeps the cart intact when an update fails', () async {
    when(() => updateCartItemUseCase.call(any(), any())).thenAnswer(
      (_) async => ErrorResponce<CartEntity>(Exception('update failed')),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having((state) => state.itemLoadings, 'itemLoadings', {
          updating('1'),
        }),
        isA<CartState>()
            .having((state) => state.itemLoadings, 'itemLoadings', isEmpty)
            .having((state) => state.errorMessage, 'error', isEmpty),
      ]),
    );
    cubit.doEvent(
      UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 4),
    );

    await emitted;
  });

  test('stops loading and keeps the cart intact when a remove fails', () async {
    when(() => removeCartItemUseCase.call(any())).thenAnswer(
      (_) async => ErrorResponce<CartEntity>(Exception('remove failed')),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having((state) => state.itemLoadings, 'itemLoadings', {
          removing('item-1'),
        }),
        isA<CartState>()
            .having((state) => state.itemLoadings, 'itemLoadings', isEmpty)
            .having((state) => state.errorMessage, 'error', isEmpty),
      ]),
    );
    cubit.doEvent(RemoveCartItemEvent(cartItemId: 'item-1'));

    await emitted;
  });

  CartItemEntity item(String productId, String id) {
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
    await seedCart(cartWithItems([item('1', 'item-1'), item('2', 'item-2')]));
    when(() => updateCartItemUseCase.call(any(), any())).thenAnswer(
      (_) async => SuccessResponce(
        cartWithItems([item('1', 'item-1'), item('2', 'item-2')]),
      ),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>()
            .having(
              (state) => state.itemLoadings,
              'itemLoadings',
              equals({updating('1')}),
            )
            .having(
              (state) => state.isItemUpdating('2'),
              'product 2 not loading',
              isFalse,
            )
            .having((state) => state.isLoading, 'loading', false),
        isA<CartState>().having(
          (state) => state.itemLoadings,
          'itemLoadings',
          isEmpty,
        ),
      ]),
    );

    cubit.doEvent(
      UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 2),
    );

    await emitted;
  });

  test('loading is tracked independently per line for removals', () async {
    await seedCart(cartWithItems([item('1', 'item-1'), item('2', 'item-2')]));
    when(() => removeCartItemUseCase.call(any())).thenAnswer(
      (_) async => SuccessResponce(cartWithItems([item('2', 'item-2')])),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>()
            .having(
              (state) => state.itemLoadings,
              'itemLoadings',
              equals({removing('item-1')}),
            )
            .having(
              (state) => state.isItemRemoving('item-2'),
              'item-2 not loading',
              isFalse,
            ),
        isA<CartState>().having(
          (state) => state.itemLoadings,
          'itemLoadings',
          isEmpty,
        ),
      ]),
    );

    cubit.doEvent(RemoveCartItemEvent(cartItemId: 'item-1'));

    await emitted;
  });

  test('does not add a product that is already in the cart', () async {
    await seedCart(cartWithItems([item('7', 'item-7')]));

    cubit.doEvent(AddToCartEvent(productId: '7', quantity: 1));
    await pumpEventQueue();

    verifyNever(() => addCartItemUseCase.call(any()));
  });

  test('still adds another product when one product is already in the cart', () async {
    await seedCart(cartWithItems([item('7', 'item-7')]));
    when(() => addCartItemUseCase.call(any())).thenAnswer(
      (_) async => SuccessResponce(
        cartWithItems([item('7', 'item-7'), item('9', 'item-9')]),
      ),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having(
          (state) => state.itemLoadings,
          'itemLoadings',
          contains(adding('9')),
        ),
        isA<CartState>().having((state) => state.addToCartSuccess, 'success', true),
      ]),
    );

    cubit.doEvent(AddToCartEvent(productId: '9', quantity: 1));

    await emitted;
  });

  test('does not dispatch duplicate requests for the same product while it is loading', () async {
    await seedCart(cartWithItems([item('1', 'item-1'), item('2', 'item-2')]));

    final completer = Completer<BaseResponce<CartEntity>>();
    when(() => updateCartItemUseCase.call(any(), any())).thenAnswer(
      (_) => completer.future,
    );

    cubit.doEvent(
      UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 2),
    );
    await pumpEventQueue();

    // A second update and an add for the same product are dropped while loading.
    cubit.doEvent(
      UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 3),
    );
    cubit.doEvent(AddToCartEvent(productId: '1', quantity: 1));
    await pumpEventQueue();

    expect(cubit.state.itemLoadings, equals({updating('1')}));
    verify(() => updateCartItemUseCase.call(any(), any())).called(1);
    verifyNever(() => addCartItemUseCase.call(any()));

    completer.complete(
      SuccessResponce(cartWithItems([item('1', 'item-1'), item('2', 'item-2')])),
    );
    await pumpEventQueue();

    expect(cubit.state.itemLoadings, isEmpty);
  });

  test('a failed update stops loading only for that product', () async {
    await seedCart(cartWithItems([item('1', 'item-1'), item('2', 'item-2')]));
    when(() => updateCartItemUseCase.call(any(), any())).thenAnswer(
      (_) async => ErrorResponce<CartEntity>(Exception('update failed')),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having(
          (state) => state.itemLoadings,
          'itemLoadings',
          equals({updating('1')}),
        ),
        isA<CartState>()
            .having((state) => state.itemLoadings, 'itemLoadings', isEmpty)
            .having((state) => state.errorMessage, 'error', isEmpty)
            .having((state) => state.data, 'cart unchanged', isNotNull),
      ]),
    );

    cubit.doEvent(
      UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 2),
    );

    await emitted;
  });

  test('a refresh clears any stale per-item loading', () async {
    await seedCart(cartWithItems([item('1', 'item-1')]));

    final completer = Completer<BaseResponce<CartEntity>>();
    when(() => removeCartItemUseCase.call(any())).thenAnswer(
      (_) => completer.future,
    );

    cubit.doEvent(RemoveCartItemEvent(cartItemId: 'item-1'));
    await pumpEventQueue();
    expect(cubit.state.isItemRemoving('item-1'), isTrue);

    when(() => getCartUseCase.call()).thenAnswer(
      (_) async => SuccessResponce(cartWithItems([item('1', 'item-1')])),
    );
    cubit.doEvent(CartRefreshRequestedEvent());
    await pumpEventQueue();

    expect(cubit.state.itemLoadings, isEmpty);

    completer.complete(SuccessResponce(cart));
    await pumpEventQueue();
  });
}
