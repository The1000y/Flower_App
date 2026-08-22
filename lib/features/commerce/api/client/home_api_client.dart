import 'package:dio/dio.dart';
import 'package:flower_app/config/routing/app_routes.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/best_seller_response.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/categories_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/home_section_response.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasions_response_dto.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

// import '../models/home_sections_response_dto.dart';
// import '../models/categories_response_dto.dart';
// import '../models/best_seller_response_dto.dart';
// import '../models/occasions_response_dto.dart';

part 'home_api_client.g.dart';
@singleton
@RestApi()
abstract class HomeApi {
  @factoryMethod
  factory HomeApi(Dio dio) = _HomeApi;

  @GET(Routes.homeSection)
  Future<HomeSectionsResponseDto> getSections();

  @GET(Routes.categories)
  Future<CategoriesResponseDto> getCategories();

  @GET(Routes.bestSeller)
  Future<BestsellersResponseDto> getBestSeller();

  @GET(Routes.occasion)
  Future<OccasionsResponseDto> getOccasions();
}
