import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/model/request/cart_request/add_cart_item_request_dto.dart';
import 'package:flower_app/features/commerce/data/model/request/cart_request/update_cart_item_request_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/categories_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';

import '../../model/responce/cart_response/cart_response_dto.dart';

abstract interface class CommerceRemoteDataSource {
  Future<BaseResponce<List<OccasionDto>>> getOccasions();
  Future<BaseResponce<ProductsResponseDto>> getProducts(int occasionId, {int page = 1});
  Future<BaseResponce<List<CategoriesResponseDto>>> getCategories();
  //Future<BaseResponce<CartResponseDto>> getCart();
  //<BaseResponce<CartResponseDto>> addToCart(AddCartItemRequestDto request);
  //<BaseResponce<CartResponseDto>> updateCartItemQuantity(UpdateCartItemRequestDto request);
  //<BaseResponce<CartResponseDto>> removeCartItem(String cartItemId);
}
