import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/model/request/cart_request/add_cart_item_request_dto.dart';
import 'package:flower_app/features/commerce/data/model/request/cart_request/update_cart_item_request_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/item_Dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/cart_response/cart_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';

abstract interface class CommerceLocalDataSource {
  Future<BaseResponce<List<CategoryDto>>> getCategories();
  Future<BaseResponce<ProductsResponseDto>> getProducts();
  Future<BaseResponce<ProductsResponseDto>> getProductsForOccasion(int occasionId, {int page = 1});
  Future<BaseResponce<List<ItemDto>>> getBestSellers();
  Future<BaseResponce<List<SectionDto>>> getSections();
  Future<BaseResponce<List<OccasionDto>>> getOccasions();
  Future<BaseResponce<CartResponseDto>> addCartItem(AddCartItemRequestDto request);
  Future<BaseResponce<CartResponseDto>> updateCartItem(int productId, UpdateCartItemRequestDto request);
  Future<BaseResponce<CartResponseDto>> removeCartItem(int productId);
}
