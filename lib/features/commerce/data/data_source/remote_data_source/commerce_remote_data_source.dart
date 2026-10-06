import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/model/request/cart_request/add_cart_item_request_dto.dart';
import 'package:flower_app/features/commerce/data/model/request/cart_request/update_cart_item_request_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/cart_response/cart_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';

abstract interface class CommerceRemoteDataSource {
  Future<BaseResponce<List<SectionDto>>> getSections();
  Future<BaseResponce<List<CategoryDto>>> getCategories();
  Future<BaseResponce<List<OccasionDto>>> getOccasions({int pageNumber = 1, int pageSize = 10});
  Future<BaseResponce<ProductsResponseDto>> getProducts({String? categoryId, String? occasionId, String? keyword, String? sortBy, int page = 1, int pageSize = 10});

  Future<BaseResponce<CartResponseDto>> getCart();
  Future<BaseResponce<CartResponseDto>> addCartItem(
    AddCartItemRequestDto request,
  );
  Future<BaseResponce<CartResponseDto>> updateCartItemQuantity(
    String productId,
    UpdateCartItemRequestDto request,
  );
  Future<BaseResponce<CartResponseDto>> removeCartItem(String cartItemId);
  Future<BaseResponce<CartResponseDto>> clearCart();
}
