import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/api/data_source_impl/local/local_data_source_impl.dart';
import 'package:flower_app/features/commerce/data/model/request/cart_request/add_cart_item_request_dto.dart';
import 'package:flower_app/features/commerce/data/model/request/cart_request/update_cart_item_request_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/cart_response/cart_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = LocalDataSourceImpl();
  });

  group('cart operations', () {
    test('getCart returns the seeded cart with correct totals', () async {
      final result = await dataSource.getCart();

      expect(result, isA<SuccessResponce<CartResponseDto>>());
      final cart = (result as SuccessResponce<CartResponseDto>).data.data;
      expect(cart.items.length, 3);
      expect(cart.subtotal, 2200);
      expect(cart.deliveryFee, 100);
      expect(cart.total, 2300);
    });

    test('addToCart increments the quantity for an existing product', () async {
      final result = await dataSource.addToCart(
        AddCartItemRequestDto(productId: 1, quantity: 2),
      );

      final cart = (result as SuccessResponce<CartResponseDto>).data.data;
      final item = cart.items.firstWhere((e) => e.productId == 1);
      expect(cart.items.length, 3);
      expect(item.quantity, 3);
      expect(item.lineSubtotal, 1800);
    });

    test('addToCart adds a new product to the cart', () async {
      final result = await dataSource.addToCart(
        AddCartItemRequestDto(productId: 4, quantity: 1),
      );

      final cart = (result as SuccessResponce<CartResponseDto>).data.data;
      expect(cart.items.length, 4);
      final item = cart.items.firstWhere((e) => e.productId == 4);
      expect(item.productName, 'Pink Tulips Bouquet');
      expect(item.unitPrice, 650);
      expect(item.lineSubtotal, 650);
      expect(item.inStock, isTrue);
    });

    test('addToCart returns an error for an unknown product', () async {
      final result = await dataSource.addToCart(
        AddCartItemRequestDto(productId: 999, quantity: 1),
      );

      expect(result, isA<ErrorResponce<CartResponseDto>>());
      expect(
        (result as ErrorResponce<CartResponseDto>).error.toString(),
        contains('Product not found'),
      );
    });

    test('updateCartItemQuantity updates the quantity and subtotal', () async {
      final result = await dataSource.updateCartItemQuantity(
        'cart-item-1',
        UpdateCartItemRequestDto(quantity: 4),
      );

      final cart = (result as SuccessResponce<CartResponseDto>).data.data;
      final item = cart.items.firstWhere((e) => e.id == 'cart-item-1');
      expect(item.quantity, 4);
      expect(item.lineSubtotal, 2400);
    });

    test('updateCartItemQuantity returns an error when the item is missing',
        () async {
      final result = await dataSource.updateCartItemQuantity(
        'missing-item',
        UpdateCartItemRequestDto(quantity: 4),
      );

      expect(result, isA<ErrorResponce<CartResponseDto>>());
      expect(
        (result as ErrorResponce<CartResponseDto>).error.toString(),
        contains('Cart item not found'),
      );
    });

    test('removeCartItem removes the item from the cart', () async {
      final result = await dataSource.removeCartItem('cart-item-1');

      expect(result, isA<SuccessResponce<CartResponseDto>>());
      final cart = (result as SuccessResponce<CartResponseDto>).data.data;
      expect(cart.items.length, 2);
      expect(cart.items.any((e) => e.id == 'cart-item-1'), isFalse);
    });

    test('removeCartItem keeps the cart unchanged for an unknown id', () async {
      final result = await dataSource.removeCartItem('missing-item');

      expect(result, isA<SuccessResponce<CartResponseDto>>());
      final cart = (result as SuccessResponce<CartResponseDto>).data.data;
      expect(cart.items.length, 3);
    });
  });
}