import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/product_Dto.dart' as best_seller;
import 'package:flower_app/features/commerce/data/model/responce/cart_response/cart_item_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/cart_response/cart_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
import 'package:injectable/injectable.dart';

import '../../../data/model/request/cart_request/add_cart_item_request_dto.dart';
import '../../../data/model/request/cart_request/update_cart_item_request_dto.dart';

@LazySingleton(as: CommerceLocalDataSource)
class LocalDataSourceImpl implements CommerceLocalDataSource {
  static const Map<int, _LocalProduct> _catalog = {
    1: _LocalProduct(
      'Red Roses Bouquet',
      'https://loremflickr.com/600/600/rose,bouquet?lock=101',
      600,
    ),
    2: _LocalProduct(
      'Pink Roses Bouquet',
      'https://loremflickr.com/600/600/pink,rose,bouquet?lock=102',
      550,
    ),
    3: _LocalProduct(
      'White Roses Bouquet',
      'https://loremflickr.com/600/600/white,rose,bouquet?lock=103',
      500,
    ),
  };

  final List<CartItemResponseDto> _cartItems = [
    CartItemResponseDto(
      id: 'cart-item-1',
      productId: 1,
      productName: 'Red Roses Bouquet',
      productImageUrl: 'https://loremflickr.com/600/600/rose,bouquet?lock=101',
      unitPrice: 600,
      quantity: 1,
      lineSubtotal: 600,
      inStock: true,
      availableStock: 10,
      priceChanged: false,
    ),
    CartItemResponseDto(
      id: 'cart-item-2',
      productId: 2,
      productName: 'Pink Roses Bouquet',
      productImageUrl:
          'https://loremflickr.com/600/600/pink,rose,bouquet?lock=102',
      unitPrice: 550,
      quantity: 2,
      lineSubtotal: 1100,
      inStock: true,
      availableStock: 8,
      priceChanged: false,
    ),
    CartItemResponseDto(
      id: 'cart-item-3',
      productId: 3,
      productName: 'White Roses Bouquet',
      productImageUrl:
          'https://loremflickr.com/600/600/white,rose,bouquet?lock=103',
      unitPrice: 500,
      quantity: 1,
      lineSubtotal: 500,
      inStock: true,
      availableStock: 5,
      priceChanged: false,
    ),
  ];

  @override
  Future<BaseResponce<List<CategoryDto>>> getCategories() async {
    return ErrorResponce(Exception('Not implemented locally'));
  }

  @override
  Future<BaseResponce<ProductsResponseDto>> getProducts() async {
    return ErrorResponce(Exception('Not implemented locally'));
  }

  @override
  Future<BaseResponce<List<best_seller.ProductDto>>> getBestSellers() async {
    return ErrorResponce(Exception('Not implemented locally'));
  }

  @override
  Future<BaseResponce<List<SectionDto>>> getSections() async {
    return ErrorResponce(Exception('Not implemented locally'));
  }

  @override
  Future<BaseResponce<List<OccasionDto>>> getOccasions() async {
    return ErrorResponce(Exception('Not implemented locally'));
  }

  @override
  Future<BaseResponce<ProductsResponseDto>> getProductsForOccasion(
    String occasionId, {
    int page = 1,
  }) async {
    return ErrorResponce(Exception('Not implemented locally'));
  }

  CartResponseDto _buildCartResponse() {
    final subtotal = _cartItems.fold<double>(
      0,
      (sum, item) => sum + item.lineSubtotal,
    );

    const deliveryFee = 100.0;

    return CartResponseDto(
      data: CartDataDto(
        items: List<CartItemResponseDto>.from(_cartItems),
        subtotal: subtotal,
        deliveryFee: _cartItems.isEmpty ? 0 : deliveryFee,
        total: _cartItems.isEmpty ? 0 : subtotal + deliveryFee,
        hasChanges: false,
      ),
      isSuccess: true,
      message: 'Success',
      messageLocalized: 'Success',
      statusCode: '200',
    );
  }

  @override
  Future<BaseResponce<CartResponseDto>> getCart() async {
    await Future.delayed(const Duration(seconds: 2));

    return SuccessResponce<CartResponseDto>(_buildCartResponse());
  }

  @override
  Future<BaseResponce<CartResponseDto>> addToCart(
    AddCartItemRequestDto request,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final existingIndex = _cartItems.indexWhere(
      (item) => item.productId == request.productId,
    );

    if (existingIndex != -1) {
      final existingItem = _cartItems[existingIndex];

      final newQuantity = existingItem.quantity + request.quantity;

      _cartItems[existingIndex] = CartItemResponseDto(
        id: existingItem.id,
        productId: existingItem.productId,
        productName: existingItem.productName,
        productImageUrl: existingItem.productImageUrl,
        unitPrice: existingItem.unitPrice,
        quantity: newQuantity,
        lineSubtotal: existingItem.unitPrice * newQuantity,
        inStock: existingItem.inStock,
        availableStock: existingItem.availableStock,
        priceChanged: existingItem.priceChanged,
      );

      return SuccessResponce<CartResponseDto>(_buildCartResponse());
    }

    final product = _catalog[request.productId];

    if (product == null) {
      return ErrorResponce<CartResponseDto>(Exception('Product not found'));
    }

    _cartItems.add(
      CartItemResponseDto(
        id:
            'cart-item-${request.productId}-${DateTime.now().millisecondsSinceEpoch}',
        productId: request.productId,
        productName: product.name,
        productImageUrl: product.imageUrl,
        unitPrice: product.price,
        quantity: request.quantity,
        lineSubtotal: product.price * request.quantity,
        inStock: true,
        availableStock: 10,
        priceChanged: false,
      ),
    );

    return SuccessResponce<CartResponseDto>(_buildCartResponse());
  }

  @override
  Future<BaseResponce<CartResponseDto>> updateCartItemQuantity(
    String cartItemId,
    UpdateCartItemRequestDto request,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final itemIndex = _cartItems.indexWhere((item) => item.id == cartItemId);

    if (itemIndex == -1) {
      return ErrorResponce<CartResponseDto>(Exception('Cart item not found'));
    }

    final existingItem = _cartItems[itemIndex];

    _cartItems[itemIndex] = CartItemResponseDto(
      id: existingItem.id,
      productId: existingItem.productId,
      productName: existingItem.productName,
      productImageUrl: existingItem.productImageUrl,
      unitPrice: existingItem.unitPrice,
      quantity: request.quantity,
      lineSubtotal: existingItem.unitPrice * request.quantity,
      inStock: existingItem.inStock,
      availableStock: existingItem.availableStock,
      priceChanged: existingItem.priceChanged,
    );

    return SuccessResponce<CartResponseDto>(_buildCartResponse());
  }

  @override
  Future<BaseResponce<CartResponseDto>> removeCartItem(
    String cartItemId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    _cartItems.removeWhere((item) => item.id == cartItemId);

    return SuccessResponce<CartResponseDto>(_buildCartResponse());
  }
}

class _LocalProduct {
  final String name;
  final String imageUrl;
  final double price;

  const _LocalProduct(this.name, this.imageUrl, this.price);
}
