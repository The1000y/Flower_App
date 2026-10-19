import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_item_entity.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_state.dart';
import 'package:flower_app/features/commerce/presentation/cart/view/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flower_app/l10n/app_localizations_en.dart';

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

CartItemEntity buildItem({
  String id = 'item-1',
  String productId = '1',
  String name = 'Red Roses Bouquet',
  int quantity = 2,
  double unitPrice = 200,
}) {
  return CartItemEntity(
    id: id,
    productId: productId,
    productName: name,
    productImageUrl: 'https://example.com/rose.jpg',
    unitPrice: unitPrice,
    quantity: quantity,
    lineSubtotal: unitPrice * quantity,
    inStock: true,
    priceChanged: false,
  );
}

void main() {
  Future<void> pumpItem(
    WidgetTester tester, {
    CartItemEntity? item,
    CartState? state,
    VoidCallback onDelete = _noop,
    ValueChanged<int> onQuantityChanged = _noopChanged,
  }) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final cubit = MockCartCubit();
    whenListen(
      cubit,
      const Stream<CartState>.empty(),
      initialState: state ?? const CartState(),
    );

    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(375, 812),
        child: BlocProvider<CartCubit>.value(
          value: cubit,
          child: MaterialApp(
            home: Scaffold(
              body: CartItem(
                item: item ?? buildItem(),
                onDelete: onDelete,
                onQuantityChanged: onQuantityChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders the product name, unit price and subtotal', (
    tester,
  ) async {
    await pumpItem(tester, item: buildItem(unitPrice: 200, quantity: 2));

    expect(find.text('Red Roses Bouquet'), findsOneWidget);
    expect(
      find.text('${AppLocalizationsEn().currencyEGP}${200.toStringAsFixed(2)}'),
      findsOneWidget,
    );
    expect(
      find.text('${AppLocalizationsEn().currencyEGP}${400.toStringAsFixed(2)}'),
      findsOneWidget,
    );
  });

  testWidgets('fires callbacks with the requested new quantity', (
    tester,
  ) async {
    var deleted = false;
    int? latestQuantity;
    await pumpItem(
      tester,
      item: buildItem(quantity: 3),
      onDelete: () => deleted = true,
      onQuantityChanged: (newQuantity) => latestQuantity = newQuantity,
    );

    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    expect(latestQuantity, 4);

    await tester.tap(find.byIcon(Icons.remove));
    expect(latestQuantity, 2);

    await tester.tap(find.byIcon(Icons.delete));
    expect(deleted, isTrue);
  });

  testWidgets('shows the optimistic quantity while one is pending', (
    tester,
  ) async {
    await pumpItem(
      tester,
      item: buildItem(quantity: 2),
      state: const CartState(pendingQuantities: {'1': 5}),
    );

    expect(find.text('5'), findsOneWidget);
    expect(find.text('2'), findsNothing);
  });

  testWidgets('shows a loading indicator and disables actions while loading', (
    tester,
  ) async {
    await pumpItem(
      tester,
      item: buildItem(quantity: 3),
      state: const CartState(updatingProductIds: {'1'}),
      onDelete: () {},
      onQuantityChanged: (_) {},
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);
    expect(find.byIcon(Icons.remove), findsNothing);
    expect(find.text('3'), findsNothing);

    final deleteButton = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.delete),
    );
    expect(deleteButton.onPressed, isNull);
  });
}

void _noop() {}

void _noopChanged(int quantity) {}
