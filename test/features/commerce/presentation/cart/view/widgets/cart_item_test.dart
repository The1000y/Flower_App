import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_item_entity.dart';
import 'package:flower_app/features/commerce/presentation/cart/view/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

CartItemEntity buildItem({
  String id = 'item-1',
  int productId = 1,
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
    bool isLoading = false,
    VoidCallback onDelete = _noop,
    ValueChanged<int> onQuantityChanged = _noopChanged,
  }) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          home: Scaffold(
            body: CartItem(
              item: item ?? buildItem(),
              isLoading: isLoading,
              onDelete: onDelete,
              onQuantityChanged: onQuantityChanged,
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
      find.text('${AppStrings.currencyEGP}${200.toStringAsFixed(0)}'),
      findsOneWidget,
    );
    expect(
      find.text(' ${AppStrings.currencyEGP}${400.toStringAsFixed(0)}'),
      findsOneWidget,
    );
  });

  testWidgets('renders the quantity and fires callbacks', (tester) async {
    var deleted = false;
    var lastDelta = 0;
    await pumpItem(
      tester,
      item: buildItem(quantity: 3),
      onDelete: () => deleted = true,
      onQuantityChanged: (delta) => lastDelta = delta,
    );

    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    expect(lastDelta, 1);

    await tester.tap(find.byIcon(Icons.remove));
    expect(lastDelta, -1);

    await tester.tap(find.byIcon(Icons.delete));
    expect(deleted, isTrue);
  });

  testWidgets('shows a loading indicator and disables actions while loading', (
    tester,
  ) async {
    //var deleted = false;
    //var lastDelta = 0;
    await pumpItem(
      tester,
      item: buildItem(quantity: 3),
      isLoading: true,
     // onDelete: () => deleted = true,
    //  onQuantityChanged: (delta) => lastDelta = delta,
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);
    expect(find.byIcon(Icons.remove), findsNothing);
    expect(find.text('3'), findsNothing);

    final deleteButton = tester.widget<IconButton>(
      find.byIcon(Icons.delete),
    );
    expect(deleteButton.onPressed, isNull);
  });
}

void _noop() {}

void _noopChanged(int delta) {}