import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/data_source/remote_data_source/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/model/request/cart_request/add_cart_item_request_dto.dart';
import 'package:flower_app/features/commerce/data/model/request/cart_request/update_cart_item_request_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/item_Dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/cart_response/cart_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRepo)
class CommerceRepoImpl implements CommerceRepo {
  final CommerceLocalDataSource localDataSource;
  final CommerceRemoteDataSource remoteDataSource;

  CommerceRepoImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<BaseResponce<List<CategoryEntity>>> getCategories() async {
    final response = await localDataSource.getCategories();
    switch (response) {
      case SuccessResponce<List<CategoryDto>>():
        return SuccessResponce(response.data.map((e) => e.toDomain()).toList());
      case ErrorResponce<List<CategoryDto>>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<List<BestSellerEntity>>> getBestSeller() async {
    final response = await localDataSource.getBestSellers();
    switch (response) {
      case SuccessResponce<List<ItemDto>>():
        return SuccessResponce(response.data.map((e) => e.toDomain()).toList());
      case ErrorResponce<List<ItemDto>>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<List<SectionEntity>>> getSection() async {
    final response = await localDataSource.getSections();
    switch (response) {
      case SuccessResponce<List<SectionDto>>():
        return SuccessResponce(response.data.map((e) => e.toDomain()).toList());
      case ErrorResponce<List<SectionDto>>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<List<OccasionEntity>>> getOccasions() async {
    final response = await remoteDataSource.getOccasions();
    switch (response) {
      case SuccessResponce<List<OccasionDto>>():
        return SuccessResponce(response.data.map((e) => e.toDomain()).toList());
      case ErrorResponce<List<OccasionDto>>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<List<ProductEntity>>> getProducts() async {
    final response = await localDataSource.getProducts();
    switch (response) {
      case SuccessResponce<ProductsResponseDto>():
        return SuccessResponce(response.data.products);
      case ErrorResponce<ProductsResponseDto>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<PaginatedProducts>> getOccasionsProducts(int occasionId, {int page = 1}) async {
    final response = await remoteDataSource.getProducts(occasionId, page: page);
    switch (response) {
      case SuccessResponce<ProductsResponseDto>():
        return SuccessResponce(PaginatedProducts(
          items: response.data.products,
          pagination: response.data.pagination,
        ));
      case ErrorResponce<ProductsResponseDto>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<CartEntity>> addCartItem(int productId, {int quantity = 1}) async {
    final request = AddCartItemRequestDto(productId: productId, quantity: quantity);
    final response = await localDataSource.addCartItem(request);
    switch (response) {
      case SuccessResponce<CartResponseDto>():
        return SuccessResponce(response.data.toDomain());
      case ErrorResponce<CartResponseDto>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<CartEntity>> updateCartItem(int productId, int quantity) async {
    final request = UpdateCartItemRequestDto(quantity: quantity);
    final response = await localDataSource.updateCartItem(productId, request);
    switch (response) {
      case SuccessResponce<CartResponseDto>():
        return SuccessResponce(response.data.toDomain());
      case ErrorResponce<CartResponseDto>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<CartEntity>> removeCartItem(int productId) async {
    final response = await localDataSource.removeCartItem(productId);
    switch (response) {
      case SuccessResponce<CartResponseDto>():
        return SuccessResponce(response.data.toDomain());
      case ErrorResponce<CartResponseDto>():
        return ErrorResponce(response.error);
    }
  }
}
