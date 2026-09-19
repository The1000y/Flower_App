import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_state.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_item_entity.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_state.dart';
import 'package:flower_app/features/commerce/presentation/cart/view/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

class MockAddressCubit extends MockCubit<AddressState>
    implements AddressCubit {}

void main() {
  late MockCartCubit mockCubit;
  late MockAddressCubit mockAddressCubit;

  setUp(() {
    mockCubit = MockCartCubit();
    mockAddressCubit = MockAddressCubit();
  });

  Future<void> pumpApp(WidgetTester tester, CartState state) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    whenListen(mockCubit, const Stream<CartState>.empty(), initialState: state);
    whenListen(
      mockAddressCubit,
      const Stream<AddressState>.empty(),
      initialState: const AddressState(),
    );

    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<CartCubit>.value(value: mockCubit),
              BlocProvider<AddressCubit>.value(value: mockAddressCubit),
            ],
            child: const CartView(),
          ),
        ),
      ),
    );
  }

  testWidgets('renders an app bar with the cart title', (tester) async {
    await pumpApp(tester, const CartState());

    expect(find.text(AppStrings.navCart), findsOneWidget);
  });

  testWidgets('shows a loading indicator while the cart is loading', (
    tester,
  ) async {
    await pumpApp(tester, const CartState(isLoading: true));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows the error message and a retry button on failure', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const CartState(errorMessage: 'Something went wrong'),
    );

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, AppStrings.retry),
      findsOneWidget,
    );
  });

  testWidgets('shows an empty message when the cart has no items', (
    tester,
  ) async {
    await pumpApp(tester, const CartState(data: null));

    expect(find.text(AppStrings.yourCartIsEmpty), findsOneWidget);
  });

  testWidgets('renders cart items and totals when the cart is loaded', (
    tester,
  ) async {
    final cart = CartEntity(
      items: [
        CartItemEntity(
          id: 'item-1',
          productId: 1,
          productName: 'Red Roses Bouquet',
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

    await pumpApp(tester, CartState(data: cart));

    expect(find.text('Red Roses Bouquet'), findsOneWidget);
    expect(find.text('${AppStrings.currencyEGP}400.00'), findsWidgets);
  });

  testWidgets('shows loading only for the affected product', (tester) async {
    final cart = CartEntity(
      items: [
        CartItemEntity(
          id: 'item-1',
          productId: 1,
          productName: 'Red Roses Bouquet',
          productImageUrl: 'https://example.com/rose.jpg',
          unitPrice: 200,
          quantity: 2,
          lineSubtotal: 400,
          inStock: true,
          priceChanged: false,
        ),
        CartItemEntity(
          id: 'item-2',
          productId: 2,
          productName: 'White Tulips Bouquet',
          productImageUrl: 'https://example.com/tulips.jpg',
          unitPrice: 100,
          quantity: 1,
          lineSubtotal: 100,
          inStock: true,
          priceChanged: false,
        ),
      ],
      subtotal: 500,
      deliveryFee: 20,
      total: 520,
      hasChanges: false,
    );

    await pumpApp(tester, CartState(data: cart, loadingProductIds: {1}));

    // Both items remain visible (no full-page loading).
    expect(find.text('Red Roses Bouquet'), findsOneWidget);
    expect(find.text('White Tulips Bouquet'), findsOneWidget);

    // Only the loading product shows the inline indicator.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // The unaffected product keeps its quantity controls.
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.remove), findsOneWidget);

    // The affected product's delete is disabled; the other remains enabled.
    final deleteButtons = tester
        .widgetList<IconButton>(find.widgetWithIcon(IconButton, Icons.delete))
        .toList();
    expect(deleteButtons.length, 2);
    expect(deleteButtons[0].onPressed, isNull);
    expect(deleteButtons[1].onPressed, isNotNull);
  });
}
