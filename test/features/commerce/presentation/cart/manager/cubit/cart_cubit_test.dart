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
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_ui_event.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/request_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCartUseCase extends Mock implements GetCartUseCase {}

class MockAddCartItemUseCase extends Mock implements AddCartItemUseCase {}

class MockUpdateCartItemUseCase extends Mock implements UpdateCartItemUseCase {}

class MockRemoveCartItemUseCase extends Mock implements RemoveCartItemUseCase {}

class MockClearCartUseCase extends Mock implements ClearCartUseCase {}

/// True when no item operation and no optimistic quantity is outstanding.
bool _settled(CartState state) =>
    state.addingProductIds.isEmpty &&
    state.updatingProductIds.isEmpty &&
    state.removingCartItemIds.isEmpty &&
    state.pendingQuantities.isEmpty;

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

  CartCubit buildCubit({Duration? quantityDebounce}) {
    return CartCubit(
      getCartUseCase: getCartUseCase,
      addCartItemUseCase: addCartItemUseCase,
      updateCartItemUseCase: updateCartItemUseCase,
      removeCartItemUseCase: removeCartItemUseCase,
      clearCartUseCase: clearCartUseCase,
      // A zero window keeps most tests deterministic; the debounce itself is
      // covered by the dedicated tests at the end of the file.
      quantityDebounce: quantityDebounce ?? Duration.zero,
    );
  }

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
    cubit = buildCubit();
    // A successful quantity change re-reads the cart, so the fetch is stubbed
    // by default and overridden by the tests that care about its outcome.
    when(
      () => getCartUseCase.call(),
    ).thenAnswer((_) async => SuccessResponce(cart));
  });

  tearDown(() => cubit.close());

  /// Waits until every item operation and optimistic quantity has settled.
  Future<void> runSettled(CartEvent event) async {
    final settled = expectLater(
      cubit.stream,
      emitsThrough(isA<CartState>().having(_settled, 'settled', isTrue)),
    );
    cubit.doEvent(event);
    await settled;
  }

  test('has an empty initial state', () {
    expect(cubit.state.data, isNull);
    expect(cubit.state.fetch, isA<RequestIdle<CartEntity>>());
    expect(cubit.state.clear, isA<RequestIdle<CartEntity>>());
    expect(cubit.state.errorMessage, isEmpty);
    expect(cubit.state.cart.items, isEmpty);
  });

  test('gets the cart and emits loading then success', () async {
    when(
      () => getCartUseCase.call(),
    ).thenAnswer((_) async => SuccessResponce(cart));

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having((state) => state.isFetching, 'loading', true),
        isA<CartState>()
            .having((state) => state.isFetching, 'loading', false)
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
        isA<CartState>().having((state) => state.isFetching, 'loading', true),
        isA<CartState>()
            .having((state) => state.isFetching, 'loading', false)
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
            .having((state) => state.addingProductIds, 'adding', {'7'})
            .having((state) => state.isFetching, 'loading', false),
        isA<CartState>()
            .having((state) => state.data, 'data', same(cart))
            .having((state) => state.addingProductIds, 'adding', isEmpty),
      ]),
    );
    final uiEvent = expectLater(
      cubit.uiEvents,
      emits(isA<AddToCartSuccessUiEvent>()),
    );
    cubit.doEvent(AddToCartEvent(productId: '7', quantity: 3));

    await emitted;
    await uiEvent;
    final params =
        verify(() => addCartItemUseCase.call(captureAny())).captured.single
            as AddCartItemParams;
    expect(params.productId, '7');
    expect(params.quantity, 3);
  });

  test('emits a failure UI event when adding an item fails', () async {
    when(
      () => addCartItemUseCase.call(any()),
    ).thenAnswer((_) async => ErrorResponce<CartEntity>(Exception('add failed')));

    final uiEvent = expectLater(
      cubit.uiEvents,
      emits(isA<AddToCartFailureUiEvent>()),
    );

    cubit.doEvent(AddToCartEvent(productId: '7', quantity: 1));

    await uiEvent;
    expect(cubit.state.addingProductIds, isEmpty);
  });

  test(
    'an add marks only the add action as loading for that product',
    () async {
      final completer = Completer<BaseResponce<CartEntity>>();
      when(
        () => addCartItemUseCase.call(any()),
      ).thenAnswer((_) => completer.future);

      cubit.doEvent(AddToCartEvent(productId: '7', quantity: 1));
      await pumpEventQueue();

      expect(cubit.state.isProductLoading('7'), isTrue);
      expect(cubit.state.isProductUpdating('7'), isFalse);
      expect(cubit.state.isCartItemRemoving('7'), isFalse);

      completer.complete(SuccessResponce(cart));
      await pumpEventQueue();
    },
  );

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
        isA<CartState>().having((state) => state.pendingQuantities, 'pending', {
          '1': 4,
        }),
        isA<CartState>().having(
          (state) => state.updatingProductIds,
          'updating',
          {'1'},
        ),
        isA<CartState>().having(
          (state) => state.data,
          'data',
          same(refreshedCart),
        ),
        isA<CartState>().having(
          (state) => state.updatingProductIds,
          'updating',
          isEmpty,
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

  test('applies the new quantity optimistically before any request', () async {
    final completer = Completer<BaseResponce<CartEntity>>();
    when(
      () => updateCartItemUseCase.call(any(), any()),
    ).thenAnswer((_) => completer.future);

    cubit.doEvent(
      UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 4),
    );

    // The state reflects the tapped value immediately...
    expect(cubit.state.displayQuantity('1', 2), 4);
    // ...but the optimistic value is not persisted server-side yet.
    expect(cubit.state.pendingQuantities['1'], 4);

    completer.complete(SuccessResponce(cart));
    await pumpEventQueue();
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
        isA<CartState>().having(
          (state) => state.isFetching,
          'loading',
          isFalse,
        ),
        isA<CartState>().having(
          (state) => state.isFetching,
          'loading',
          isFalse,
        ),
      ]),
    );
    cubit.doEvent(
      UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 4),
    );

    await emitted;
  });

  test('keeps the cart on screen when the re-read fails', () async {
    await pumpEventQueue();
    when(
      () => getCartUseCase.call(),
    ).thenAnswer((_) async => SuccessResponce(cart));
    cubit.doEvent(GetCartItemsEvent());
    await pumpEventQueue();
    final before = cubit.state.data;

    when(
      () => updateCartItemUseCase.call(any(), any()),
    ).thenAnswer((_) async => SuccessResponce(cart));
    when(() => getCartUseCase.call()).thenAnswer(
      (_) async => ErrorResponce<CartEntity>(Exception('refetch failed')),
    );

    await runSettled(
      UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 4),
    );

    expect(cubit.state.data, same(before));
    expect(cubit.state.updatingProductIds, isEmpty);
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
        isA<CartState>().having(
          (state) => state.removingCartItemIds,
          'removing',
          {'item-1'},
        ),
        isA<CartState>().having((state) => state.data, 'data', same(cart)),
      ]),
    );
    cubit.doEvent(RemoveCartItemEvent(cartItemId: 'item-1'));

    await emitted;
    verify(() => removeCartItemUseCase.call('item-1')).called(1);
  });

  test('a remove marks only that cart line as loading', () async {
    final completer = Completer<BaseResponce<CartEntity>>();
    when(
      () => removeCartItemUseCase.call(any()),
    ).thenAnswer((_) => completer.future);

    cubit.doEvent(RemoveCartItemEvent(cartItemId: 'item-1'));
    await pumpEventQueue();

    expect(cubit.state.isCartItemRemoving('item-1'), isTrue);
    expect(cubit.state.isCartItemRemoving('item-2'), isFalse);
    expect(cubit.state.isProductLoading('item-1'), isFalse);

    completer.complete(SuccessResponce(cart));
    await pumpEventQueue();
  });

  test(
    'an update and a remove of the same product run independently',
    () async {
      final updateCompleter = Completer<BaseResponce<CartEntity>>();
      when(
        () => updateCartItemUseCase.call(any(), any()),
      ).thenAnswer((_) => updateCompleter.future);
      when(
        () => removeCartItemUseCase.call(any()),
      ).thenAnswer((_) async => SuccessResponce(cart));

      cubit.doEvent(
        UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 2),
      );
      await pumpEventQueue();

      expect(cubit.state.isProductUpdating('1'), isTrue);
      expect(cubit.state.isCartItemRemoving('item-1'), isFalse);

      // A removal for the same product is not blocked by the pending update.
      cubit.doEvent(RemoveCartItemEvent(cartItemId: 'item-1'));
      await pumpEventQueue();

      verify(() => removeCartItemUseCase.call('item-1')).called(1);

      updateCompleter.complete(SuccessResponce(cart));
      await pumpEventQueue();
    },
  );

  test(
    'removing a line by stepping below one skips the update request',
    () async {
      when(
        () => removeCartItemUseCase.call(any()),
      ).thenAnswer((_) async => SuccessResponce(cart));

      cubit.doEvent(
        UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 0),
      );
      await pumpEventQueue();

      verify(() => removeCartItemUseCase.call('item-1')).called(1);
      verifyNever(() => updateCartItemUseCase.call(any(), any()));
    },
  );

  test('clears the cart and emits the cleared state', () async {
    final emptyCart = CartEntity(
      items: const [],
      subtotal: 0,
      total: 0,
      hasChanges: false,
    );
    when(
      () => clearCartUseCase.call(),
    ).thenAnswer((_) async => SuccessResponce(emptyCart));

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
    expect(cubit.state.isFetching, isFalse);

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

  test(
    'stops loading and keeps the cart intact when an update fails',
    () async {
      when(() => updateCartItemUseCase.call(any(), any())).thenAnswer(
        (_) async => ErrorResponce<CartEntity>(Exception('update failed')),
      );

      final emitted = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<CartState>().having(
            (state) => state.pendingQuantities,
            'pending',
            {'1': 4},
          ),
          isA<CartState>().having(
            (state) => state.updatingProductIds,
            'updating',
            {'1'},
          ),
          isA<CartState>()
              .having((state) => state.updatingProductIds, 'updating', isEmpty)
              .having((state) => state.pendingQuantities, 'pending', isEmpty)
              .having((state) => state.errorMessage, 'error', isEmpty),
        ]),
      );
      cubit.doEvent(
        UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 4),
      );

      await emitted;
    },
  );

  test('stops loading and keeps the cart intact when a remove fails', () async {
    when(() => removeCartItemUseCase.call(any())).thenAnswer(
      (_) async => ErrorResponce<CartEntity>(Exception('remove failed')),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having(
          (state) => state.removingCartItemIds,
          'removing',
          {'item-1'},
        ),
        isA<CartState>()
            .having((state) => state.removingCartItemIds, 'removing', isEmpty)
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
        isA<CartState>().having((state) => state.pendingQuantities, 'pending', {
          '1': 2,
        }),
        isA<CartState>()
            .having(
              (state) => state.updatingProductIds,
              'updating',
              equals({'1'}),
            )
            .having(
              (state) => state.isProductUpdating('2'),
              'product 2 not loading',
              isFalse,
            )
            .having((state) => state.isFetching, 'loading', false),
        isA<CartState>().having(
          (state) => state.updatingProductIds,
          'updating',
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
              (state) => state.removingCartItemIds,
              'removing',
              equals({'item-1'}),
            )
            .having(
              (state) => state.isCartItemRemoving('item-2'),
              'item-2 not loading',
              isFalse,
            ),
        isA<CartState>().having(
          (state) => state.removingCartItemIds,
          'removing',
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

  test(
    'still adds another product when one product is already in the cart',
    () async {
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
            (state) => state.addingProductIds,
            'adding',
            contains('9'),
          ),
          isA<CartState>().having(
            (state) => state.addingProductIds,
            'adding',
            isEmpty,
          ),
        ]),
      );

      cubit.doEvent(AddToCartEvent(productId: '9', quantity: 1));

      await emitted;
    },
  );

  test('a failed update stops loading only for that product', () async {
    await seedCart(cartWithItems([item('1', 'item-1'), item('2', 'item-2')]));
    when(() => updateCartItemUseCase.call(any(), any())).thenAnswer(
      (_) async => ErrorResponce<CartEntity>(Exception('update failed')),
    );

    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having((state) => state.pendingQuantities, 'pending', {
          '1': 2,
        }),
        isA<CartState>().having(
          (state) => state.updatingProductIds,
          'updating',
          equals({'1'}),
        ),
        isA<CartState>()
            .having((state) => state.updatingProductIds, 'updating', isEmpty)
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
    when(
      () => removeCartItemUseCase.call(any()),
    ).thenAnswer((_) => completer.future);

    cubit.doEvent(RemoveCartItemEvent(cartItemId: 'item-1'));
    await pumpEventQueue();
    expect(cubit.state.isCartItemRemoving('item-1'), isTrue);

    when(() => getCartUseCase.call()).thenAnswer(
      (_) async => SuccessResponce(cartWithItems([item('1', 'item-1')])),
    );
    cubit.doEvent(CartRefreshRequestedEvent());
    await pumpEventQueue();

    expect(cubit.state.removingCartItemIds, isEmpty);

    completer.complete(SuccessResponce(cart));
    await pumpEventQueue();
  });

  group('quantity debounce', () {
    test(
      'collapses rapid taps into one request with the final quantity',
      () async {
        final debounced = buildCubit(
          quantityDebounce: const Duration(milliseconds: 120),
        );
        addTearDown(debounced.close);
        when(
          () => updateCartItemUseCase.call(any(), any()),
        ).thenAnswer((_) async => SuccessResponce(cart));

        debounced.doEvent(
          UpdateCartItemEvent(
            cartItemId: 'item-1',
            productId: '1',
            quantity: 2,
          ),
        );
        debounced.doEvent(
          UpdateCartItemEvent(
            cartItemId: 'item-1',
            productId: '1',
            quantity: 3,
          ),
        );
        debounced.doEvent(
          UpdateCartItemEvent(
            cartItemId: 'item-1',
            productId: '1',
            quantity: 4,
          ),
        );

        // The screen already shows the latest value, no request has been sent.
        expect(debounced.state.displayQuantity('1', 1), 4);
        verifyNever(() => updateCartItemUseCase.call(any(), any()));

        await Future<void>.delayed(const Duration(milliseconds: 250));

        final captured = verify(
          () => updateCartItemUseCase.call('1', captureAny()),
        ).captured;
        expect(captured, hasLength(1));
        expect((captured.single as UpdateCartItemParams).quantity, 4);
      },
    );

    test('debounces each product independently', () async {
      final debounced = buildCubit(
        quantityDebounce: const Duration(milliseconds: 120),
      );
      addTearDown(debounced.close);
      when(
        () => updateCartItemUseCase.call(any(), any()),
      ).thenAnswer((_) async => SuccessResponce(cart));

      debounced.doEvent(
        UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 5),
      );
      debounced.doEvent(
        UpdateCartItemEvent(cartItemId: 'item-2', productId: '2', quantity: 7),
      );

      await Future<void>.delayed(const Duration(milliseconds: 250));

      verify(() => updateCartItemUseCase.call('1', any())).called(1);
      verify(() => updateCartItemUseCase.call('2', any())).called(1);
    });

    test('close cancels every pending debounce timer', () async {
      final debounced = buildCubit(
        quantityDebounce: const Duration(milliseconds: 120),
      );
      when(
        () => updateCartItemUseCase.call(any(), any()),
      ).thenAnswer((_) async => SuccessResponce(cart));

      debounced.doEvent(
        UpdateCartItemEvent(cartItemId: 'item-1', productId: '1', quantity: 3),
      );
      await debounced.close();

      await Future<void>.delayed(const Duration(milliseconds: 250));

      verifyNever(() => updateCartItemUseCase.call(any(), any()));
    });
  });
}
