import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_strings/api_strings.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/categories_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/home_sections_response.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasions_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_details_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'commerce_api_client.g.dart';

@singleton
@RestApi()
abstract class CommerceApiClient {
  @factoryMethod
  factory CommerceApiClient(Dio dio) = _CommerceApiClient;

  @GET('${ApiStrings.products}/{id}')
  Future<ProductDetailsResponseDto> getProductDetails(@Path('id') String id);

  @GET(ApiStrings.homeSections)
  Future<HomeSectionsResponse> getHomeSections();

  @GET(ApiStrings.categories)
  Future<CategoriesResponseDto> getCategories();

  @GET(ApiStrings.occasions)
  Future<OccasionsResponseDto> getOccasions(
    @Query('pageNumber') int pageNumber,
    @Query('pageSize') int pageSize,
  );

  @GET(ApiStrings.products)
  Future<ProductsResponseDto> getProducts(
    @Query('categoryId') String? categoryId,
    @Query('occasionId') String? occasionId,
    @Query('keyword') String? keyword,
    @Query('sortBy') String? sortBy,
    @Query('page') int page,
    @Query('pageSize') int pageSize,
  );
}
