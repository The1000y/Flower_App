import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';

import '../models/cart/add_cart_item_params.dart';
import '../models/cart/update_cart_item_params.dart';

abstract interface class CommerceRepo {
  Future<BaseResponce<List<CategoryEntity>>> getCategories();

  Future<BaseResponce<List<BestSellerEntity>>> getBestSeller();

  Future<BaseResponce<List<SectionEntity>>> getSection();

  Future<BaseResponce<List<OccasionEntity>>> getOccasions();

  Future<BaseResponce<List<ProductEntity>>> getProducts();
  Future<BaseResponce<PaginatedProducts>> getOccasionsProducts(
    String occasionId, {
    int page = 1,
  });

  Future<BaseResponce<CartEntity>> getCart();

  Future<BaseResponce<CartEntity>> addToCart(AddCartItemParams params);

  /// The backend PATCH route is keyed by the catalogue product id
  /// (`/cart/api/cart/items/:productId`), not by the cart line id.
  Future<BaseResponce<CartEntity>> updateCartItemQuantity(
    String productId,
    UpdateCartItemParams params,
  );

  /// The backend DELETE route is keyed by the cart line id
  /// (`/cart/cart/items/:id`).
  Future<BaseResponce<CartEntity>> removeCartItem(String cartItemId);

  Future<BaseResponce<CartEntity>> clearCart();
}

