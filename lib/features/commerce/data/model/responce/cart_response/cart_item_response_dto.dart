import 'package:flower_app/features/commerce/domain/entities/cart/cart_item_entity.dart';

/// The backend may serialise `productId` as either a number or a string
/// depending on the catalogue it was created from, so accept both.
String cartIdFromJson(Object? value) => value?.toString() ?? '';

/// Reads a monetary value the backend may send as a number or as a string.
double cartDoubleFromJson(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

/// Reads a cart line total that the backend sends as `lineSubtotal` on most
/// routes but as `lineTotal` on the quantity route.
double cartLineSubtotalFromJson(Object? lineSubtotal, Object? lineTotal) {
  return cartDoubleFromJson(lineSubtotal ?? lineTotal);
}

/// Parsed by hand on purpose.
///
/// The quantity route (`PATCH /cart/api/cart/items/{productId}`) answers with a
/// reduced line that carries only `id`, `productId`, `quantity`, `unitPrice`
/// and `lineTotal`, while the fetch, add and remove routes send the full line.
/// Generated `as` casts made the missing keys throw a `TypeError`, which the
/// repository turned into a failure and left the cart on screen untouched, so
/// the fields absent from the reduced line are defaulted here instead.
class CartItemResponseDto {
  final String id;

  final String productId;
  final String productName;
  final String productImageUrl;

  final double unitPrice;

  final int quantity;

  final double lineSubtotal;
  final bool inStock;

  final int? availableStock;

  final bool priceChanged;

  CartItemResponseDto({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.unitPrice,
    required this.quantity,
    required this.lineSubtotal,
    required this.inStock,
    this.availableStock,
    required this.priceChanged,
  });

  factory CartItemResponseDto.fromJson(Map<String, dynamic> json) {
    return CartItemResponseDto(
      id: cartIdFromJson(json['id']),
      productId: cartIdFromJson(json['productId']),
      productName: json['productName']?.toString() ?? '',
      productImageUrl: json['productImageUrl']?.toString() ?? '',
      unitPrice: cartDoubleFromJson(json['unitPrice']),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      lineSubtotal: cartLineSubtotalFromJson(
        json['lineSubtotal'],
        json['lineTotal'],
      ),
      inStock: json['inStock'] as bool? ?? true,
      availableStock: (json['availableStock'] as num?)?.toInt(),
      priceChanged: json['priceChanged'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'productName': productName,
    'productImageUrl': productImageUrl,
    'unitPrice': unitPrice,
    'quantity': quantity,
    'lineSubtotal': lineSubtotal,
    'inStock': inStock,
    'availableStock': availableStock,
    'priceChanged': priceChanged,
  };

  CartItemEntity toDomain() => CartItemEntity(
    id: id,
    productId: productId,
    productName: productName,
    productImageUrl: productImageUrl,
    unitPrice: unitPrice,
    quantity: quantity,
    lineSubtotal: lineSubtotal,
    inStock: inStock,
    availableStock: availableStock,
    priceChanged: priceChanged,
  );
}
