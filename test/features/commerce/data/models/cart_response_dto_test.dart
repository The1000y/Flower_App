import 'package:flower_app/features/commerce/data/model/responce/cart_response/cart_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';

/// Captured from the live gateway, which answers the cart routes with two
/// different line shapes.
Map<String, dynamic> getCartPayload() => {
  'success': true,
  'message': 'Request completed successfully',
  'data': {
    'id': 'a3f4e162-bdd7-4a86-abaf-cb7fba34f72c',
    'customerId': '01a0e798-c252-7f86-a203-250147093201',
    'items': [
      {
        'id': 'd886a44c-80ba-4810-8493-f8f4f3ac7376',
        'productId': '01a0e738-4dd1-702d-be29-065d47e38a6d',
        'productName': 'Fresh Flower Arrangement',
        'productImageUrl': 'categories/tulip_flower.png',
        'unitPrice': 1500.00,
        'quantity': 9,
        'lineSubtotal': 13500.00,
        'inStock': true,
        'availableStock': 50,
        'priceChanged': false,
      },
    ],
    'subtotal': 13500.00,
    'deliveryFee': 0,
    'total': 13500.00,
    'hasChanges': false,
  },
  'error': null,
};

/// The quantity route returns a reduced line: no name, image or stock, and the
/// line total is keyed `lineTotal`. Missing keys used to throw a `TypeError`
/// that the repository reported as a failed update.
Map<String, dynamic> quantityUpdatePayload() => {
  'success': true,
  'message': 'Request completed successfully',
  'data': {
    'id': 'a3f4e162-bdd7-4a86-abaf-cb7fba34f72c',
    'customerId': '01a0e798-c252-7f86-a203-250147093201',
    'subtotal': 12000.00,
    'total': 12000.00,
    'items': [
      {
        'id': 'd886a44c-80ba-4810-8493-f8f4f3ac7376',
        'productId': '01a0e738-4dd1-702d-be29-065d47e38a6d',
        'quantity': 8,
        'unitPrice': 1500.00,
        'lineTotal': 12000.00,
      },
    ],
  },
  'error': null,
};

void main() {
  group('CartResponseDto', () {
    test('parses the full line returned by the cart fetch', () {
      final cart = CartResponseDto.fromJson(getCartPayload()).toDomain();

      final item = cart.items.single;
      expect(item.quantity, 9);
      expect(item.productName, 'Fresh Flower Arrangement');
      expect(item.productImageUrl, 'categories/tulip_flower.png');
      expect(item.lineSubtotal, 13500.00);
      expect(item.inStock, isTrue);
      expect(item.availableStock, 50);
      expect(item.priceChanged, isFalse);
      expect(cart.total, 13500.00);
    });

    test('parses the reduced line returned by the quantity route', () {
      final cart = CartResponseDto.fromJson(quantityUpdatePayload()).toDomain();

      final item = cart.items.single;
      expect(item.quantity, 8);
      expect(item.unitPrice, 1500.00);
      // `lineTotal` is accepted as the line total.
      expect(item.lineSubtotal, 12000.00);
      expect(cart.subtotal, 12000.00);
      expect(cart.total, 12000.00);
    });

    test('defaults the display fields the reduced line omits', () {
      final cart = CartResponseDto.fromJson(quantityUpdatePayload()).toDomain();

      final item = cart.items.single;
      expect(item.productName, '');
      expect(item.productImageUrl, '');
      expect(item.inStock, isTrue);
      expect(item.availableStock, isNull);
      expect(item.priceChanged, isFalse);
    });

    test('tolerates a missing delivery fee and has-changes flag', () {
      final payload = getCartPayload();
      (payload['data'] as Map<String, dynamic>)
        ..remove('deliveryFee')
        ..remove('hasChanges');

      final cart = CartResponseDto.fromJson(payload).toDomain();

      expect(cart.deliveryFee, isNull);
      expect(cart.hasChanges, isFalse);
    });

    test('accepts a numeric product id', () {
      final payload = getCartPayload();
      ((payload['data'] as Map)['items'] as List).first['productId'] = 42;

      final cart = CartResponseDto.fromJson(payload).toDomain();

      expect(cart.items.single.productId, '42');
    });

    test('falls back to an empty cart when there is no payload', () {
      final cart = CartResponseDto.fromJson({'success': false}).toDomain();

      expect(cart.items, isEmpty);
      expect(cart.total, 0);
    });
  });
}
